from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.contrib.auth.models import User
from django.db import transaction
from django.urls import reverse # Added import for reverse
from django.core.files.uploadedfile import UploadedFile
from .forms import (
		CompanyBasicInfoForm, CompanyDescriptionForm, 
		CompanyBrandingForm, CompanyInvitationForm,
		CompanyMemberRoleForm, JobForm

)
from .models import CompanyMembership, UserProfile, CompanyInvitation, Job
from django.contrib.auth.decorators import login_required
from .decorators import company_admin_required, company_member_required

@login_required
def company_onboarding_wizard(request):
		# Define the forms for each step
		FORMS = [
				('basic_info', CompanyBasicInfoForm),
				('description', CompanyDescriptionForm),
				('branding', CompanyBrandingForm),
		]
		TEMPLATES = {
				'basic_info': 'company/company_onboarding_wizard.html',
				'description': 'company/company_onboarding_wizard.html',
				'branding': 'company/company_onboarding_wizard.html',
		}

		# Get current step from session or query params
		current_step_name = request.GET.get('step', FORMS[0][0])
		current_step_index = next((i for i, (name, _) in enumerate(FORMS) if name == current_step_name), 0)
		current_step_name, CurrentForm = FORMS[current_step_index]

		# Get company associated with the logged-in user
		try:
				user_company_membership = CompanyMembership.objects.get(user=request.user, role='admin')
				company_instance = user_company_membership.company
		except CompanyMembership.DoesNotExist:
				messages.error(request, "No se encontró una empresa asociada a tu cuenta de administrador. Por favor, valida tu RUT para crear una.")
				return redirect('validate') # Redirect to validate page if no company is found

		# Initialize form data from session
		session_data = request.session.get('company_onboarding_data', {})

		if request.method == 'POST':
				form = CurrentForm(request.POST, request.FILES, instance=company_instance)
				if form.is_valid():
						if current_step_name == 'branding':
								# For branding step, update instance with session data before saving
								session_data = request.session.get('company_onboarding_data', {})
								for key, value in session_data.items():
										setattr(company_instance, key, value)
								
								# Now save the form, which will also save the updated instance
								form.save()

								messages.success(request, "¡Perfil de empresa completado con éxito!")
								del request.session['company_onboarding_data'] # Clear session data
								return redirect('company_profile')
						else:
								# For other steps, save current step data to session
								step_data = {k: v for k, v in form.cleaned_data.items() if not isinstance(v, UploadedFile)}
								session_data.update(step_data)
								request.session['company_onboarding_data'] = session_data

								# Check for next step
								next_step_index = current_step_index + 1
								if next_step_index < len(FORMS):
										next_step_name = FORMS[next_step_index][0]
										base_url = reverse('company_onboarding_wizard')
										return redirect(f'{base_url}?step={next_step_name}')
								else:
										# This else block should ideally not be reached for non-branding final steps
										# as branding is the last step. If it were, it would need to save all session data.
										messages.error(request, "Error interno: Flujo de asistente inesperado.")
										return redirect('company_profile') # Fallback

				else:
						# Form is invalid, re-render with errors
						pass # Errors will be passed to template
		else:
				# GET request, initialize form with instance data or session data
				form = CurrentForm(instance=company_instance, initial=session_data)

		# Context for template
		context = {
				'form': form,
				'company': company_instance,
				'current_step_name': current_step_name,
				'current_step_index': current_step_index,
				'total_steps': len(FORMS),
				'prev_step_name': FORMS[current_step_index - 1][0] if current_step_index > 0 else None,
				'next_step_name': FORMS[current_step_index + 1][0] if current_step_index < len(FORMS) - 1 else None,
		}
		return render(request, TEMPLATES[current_step_name], context)

@login_required
@company_member_required
def company_profile(request):
    try:
        # Get the first company associated with the logged-in user
        user_company_membership = CompanyMembership.objects.filter(user=request.user).first()
        if not user_company_membership:
            # This case should be caught by the decorator, but it's good practice
            raise CompanyMembership.DoesNotExist
        company_instance = user_company_membership.company
    except CompanyMembership.DoesNotExist:
        messages.info(request, "No se encontró una empresa asociada a tu cuenta.")
        return redirect('user_index') # Redirect to a safe page

    return render(request, 'company/profile_emp.html', {'company': company_instance})

@login_required
def company_index(request):
		try:
				user_company_membership = CompanyMembership.objects.filter(user=request.user).first()
				if not user_company_membership:
						raise CompanyMembership.DoesNotExist
				company_instance = user_company_membership.company
		except CompanyMembership.DoesNotExist:
				company_instance = None
				messages.error(request, "No tienes una empresa asociada.")
				return redirect('user_index')

		invitation_form = CompanyInvitationForm() # Initialize for GET and default POST
		role_form = CompanyMemberRoleForm() # Initialize for GET and default POST

		is_admin = (user_company_membership.role == 'admin') if user_company_membership else False

		if request.method == 'POST':
				action = request.POST.get('action')
				print(f"DEBUG: company_index - POST request. Action: {action}, Is Admin: {is_admin}")

				if not is_admin:
						messages.error(request, "No tienes permisos de administrador para realizar esta acción.")
						return redirect('user_index')

				if action == 'invite_user':
						invitation_form = CompanyInvitationForm(request.POST)
						if invitation_form.is_valid():
								invitation = invitation_form.save(commit=False)
								invitation.company = company_instance
								invitation.save()
								messages.success(request, f"Invitación enviada a {invitation.email}")
								return redirect('company_index')
						else:
								print(invitation_form.errors) # Debugging line
								messages.error(request, "Error al enviar la invitación. Por favor, revisa los datos.")
				elif action == 'edit_user':
						member_id = request.POST.get('member_id')
						try:
								member = CompanyMembership.objects.get(pk=member_id, company=company_instance)
								# Update role
								new_role = request.POST.get('role')
								if new_role and new_role in dict(CompanyMembership.ROLE_CHOICES).keys():
										member.role = new_role
								
								# Update email
								new_email = request.POST.get('email')
								if new_email and member.user.email != new_email:
										# Optional: Check if email is already in use by another user
										if User.objects.filter(email=new_email).exclude(pk=member.user.pk).exists():
												messages.error(request, f"El email {new_email} ya está en uso por otro usuario.")
										else:
												member.user.email = new_email
												member.user.save()

								member.save()
								messages.success(request, f"Datos de {member.user.get_full_name()} actualizados.")

						except CompanyMembership.DoesNotExist:
								messages.error(request, "Miembro no encontrado.")
						return redirect('company_index')

				elif action == 'delete_user':
						member_id = request.POST.get('member_id')
						try:
								# Use a transaction to ensure data integrity
								with transaction.atomic():
										member = CompanyMembership.objects.get(pk=member_id, company=company_instance)
										user_to_update = member.user
										user_name = user_to_update.get_full_name()

										# Prevent admin from deleting themselves
										if user_to_update == request.user:
												messages.error(request, "No puedes eliminarte a ti mismo.")
												# Must return here to avoid executing further
												return redirect('company_index')

										# Delete the membership
										member.delete()

										# Check if the user has any other company memberships
										if not CompanyMembership.objects.filter(user=user_to_update).exists():
												# If not, demote their global role to 'usuario'
												user_profile = UserProfile.objects.get(user=user_to_update)
												user_profile.rol = 'usuario'
												user_profile.save()
												messages.success(request, f"Usuario {user_name} eliminado de la empresa. Su rol ha sido cambiado a Usuario estándar.")
										else:
												messages.success(request, f"Usuario {user_name} eliminado de la empresa.")

						except CompanyMembership.DoesNotExist:
								messages.error(request, "Miembro no encontrado.")
						except UserProfile.DoesNotExist:
								messages.error(request, "No se encontró el perfil del usuario para actualizar su rol.")
						
						return redirect('company_index')

		members = CompanyMembership.objects.filter(company=company_instance)

		return render(request, 'company/company_index.html', {
				'company': company_instance,
				'user': request.user,
				'invitation_form': invitation_form,
				'members': members,
				'role_form': role_form,
				'is_admin': is_admin # Pass is_admin to template for conditional rendering
		})

@login_required
def company_users(request):
		try:
				user_company_membership = CompanyMembership.objects.filter(user=request.user).first()
				if not user_company_membership:
						raise CompanyMembership.DoesNotExist
				company_instance = user_company_membership.company
				members = CompanyMembership.objects.filter(company=company_instance)
		except CompanyMembership.DoesNotExist:
				company_instance = None
				members = []
				messages.error(request, "No tienes una empresa asociada.")
				return redirect('user_index')

		return render(request, 'company/company_users.html', {
				'company': company_instance,
				'members': members
		})

@login_required
def company_invitations(request):
		try:
				user_company_membership = CompanyMembership.objects.filter(user=request.user).first()
				if not user_company_membership:
						raise CompanyMembership.DoesNotExist
				company_instance = user_company_membership.company
				invitations = CompanyInvitation.objects.filter(company=company_instance)
		except CompanyMembership.DoesNotExist:
				company_instance = None
				invitations = []
				messages.error(request, "No tienes una empresa asociada.")
				return redirect('user_index')

		return render(request, 'company/company_invitations.html', {
				'company': company_instance,
				'invitations': invitations
		})

@login_required
def job_create(request):
		# assuming you know which company is creating the job
		# (for example, from the logged-in user)
		company = CompanyMembership.objects.filter(user=request.user).first().company  # adjust as needed
		if request.method == "POST":
				print('test')
				form = JobForm(request.POST)
				if form.is_valid():
						job = form.save(commit=False)
						job.company = company  # ← set automatically
						job.requirements = form.cleaned_data["requirements"]
						job.posted_by = request.user
						job.save()
						form.save_m2m()
						return redirect('company_index')
		else:
				form = JobForm()
		return render(request, "partials/jobForm.html", {"form": form})


def job_detail(request,id:int):
		job = get_object_or_404(Job, pk=int(id))
		return render(request, "partials/Job.html", {"job": job})
