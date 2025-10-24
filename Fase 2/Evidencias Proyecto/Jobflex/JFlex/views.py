from django.core.paginator import Paginator
from django.shortcuts import render, redirect
from django.http import JsonResponse
from django.contrib.auth import login
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User
from django.contrib.auth import views as auth_views
from django.contrib import messages
from django.core.mail import EmailMessage
from django.template.loader import render_to_string
from django.db import transaction
from django.urls import reverse # Added import for reverse
from django.core.files.uploadedfile import UploadedFile
from .forms import SignUpForm, CompanyAdminSignUpForm, VerificationForm, CompanyBasicInfoForm, CompanyDescriptionForm, CompanyBrandingForm, CompanyInvitationForm, CompanyMemberRoleForm
from .models import EmpValidation, Company, CompanyMembership, UserProfile, CompanyInvitation,Job
import random
from .decorators import company_admin_required, company_member_required


def signup(request):
    if request.method == 'POST':
        form = SignUpForm(request.POST)
        if form.is_valid():
            user = form.save(commit=False)
            user.is_active = False
            user.save()

            # Create UserProfile
            UserProfile.objects.create(user=user, rol='usuario')

            # Generate verification code
            code = str(random.randint(100000, 999999))
            request.session['verification_code'] = code
            request.session['user_pk_for_verification'] = user.pk

            mail_subject = f'Tu código de activación para JobFlex es {code}'
            message = render_to_string('registration/code_email.html', {
                'code': code,
            })
            to_email = form.cleaned_data.get('email')
            email = EmailMessage(
                        mail_subject, message, to=[to_email]
            )
            email.send()
            return redirect('verify_code')
    else:
        form = SignUpForm()
    return render(request, 'registration/register.html', {'form': form})



def verify_code(request):
    if request.method == 'POST':
        form = VerificationForm(request.POST)
        if form.is_valid():
            entered_code = form.cleaned_data['code']
            stored_code = request.session.get('verification_code')
            user_pk = request.session.get('user_pk_for_verification')

            if entered_code == stored_code:
                try:
                    user = User.objects.get(pk=user_pk)
                    user.is_active = True
                    user.save()
                    login(request, user, backend='JFlex.backends.EmailBackend')
                    # Clear session data
                    del request.session['verification_code']
                    del request.session['user_pk_for_verification']

                    # Check for pending invitations
                    try:
                        invitation = CompanyInvitation.objects.get(email=user.email, status='pending')
                        print(f"DEBUG: verify_code - Found pending invitation for {user.email}. Company: {invitation.company.name}, Role: {invitation.role}")
                        company = invitation.company

                        # Update user profile
                        user.profile.rol = 'empresa'
                        user.profile.save()
                        print(f"DEBUG: verify_code - User {user.email} profile role updated to 'empresa'.")

                        # Create company membership
                        CompanyMembership.objects.create(
                            user=user,
                            company=company,
                            role=invitation.role
                        )
                        print(f"DEBUG: verify_code - CompanyMembership created for {user.email} in {company.name} with role {invitation.role}.")

                        # Update invitation status
                        invitation.status = 'accepted'
                        invitation.save()
                        print(f"DEBUG: verify_code - Invitation status for {user.email} updated to 'accepted'.")

                        messages.success(request, f'¡Bienvenido a {company.name}!')
                        return redirect('company_index')

                    except CompanyInvitation.DoesNotExist:
                        print(f"DEBUG: verify_code - No pending invitation found for {user.email}.")
                        # No invitation found, proceed with normal flow
                        if hasattr(user, 'profile') and user.profile.rol == 'empresa':
                            return redirect('company_onboarding_wizard')
                        else:
                            return redirect('user_index')

                except User.DoesNotExist:
                    form.add_error(None, "Usuario no encontrado.")
            else:
                form.add_error('code', "El código introducido no es correcto.")
    else:
        form = VerificationForm()
    return render(request, 'registration/enter_code.html', {'form': form})

def index(req):
    if req.user.is_authenticated:
        return redirect('user_index')
    return render(req, 'index.html')

def register_emp(req):
    if req.method == 'POST':
        rut = req.POST.get('rut') # Get RUT from POST data
        form = CompanyAdminSignUpForm(req.POST)

        try:
            emp_validation = EmpValidation.objects.get(rut_completo=rut)
        except EmpValidation.DoesNotExist:
            messages.error(req, "El RUT proporcionado no es válido o no fue encontrado.")
            return redirect('validate')

        if form.is_valid():
            print("DEBUG: register_emp - Form is valid.")
            try:
                with transaction.atomic():
                    # 1. Create User
                    user = form.save(commit=False)
                    user.is_active = False # User is inactive until email is verified
                    print(f"DEBUG: register_emp - User username before save: {user.username}")
                    user.save()
                    print(f"DEBUG: register_emp - User created: {user.username}")

                    # 2. Create UserProfile
                    UserProfile.objects.create(user=user, rol='empresa')
                    print(f"DEBUG: register_emp - UserProfile created for user: {user.username}")

                    # 3. Create Company
                    company = Company.objects.create(
                        validation=emp_validation,
                        name=form.cleaned_data['nombre_comercial'],
                        industry=None # Se pueden añadir más campos después
                    )
                    print(f"DEBUG: register_emp - Company created: {company.name}")

                    # 4. Create CompanyMembership (if it doesn't already exist)
                    if not CompanyMembership.objects.filter(user=user, company=company).exists():
                        CompanyMembership.objects.create(
                            user=user,
                            company=company,
                            role='admin'
                        )
                        print(f"DEBUG: register_emp - CompanyMembership created for user: {user.username} in company: {company.name}")
                
                # Generate verification code and send email
                code = str(random.randint(100000, 999999))
                req.session['verification_code'] = code
                req.session['user_pk_for_verification'] = user.pk

                mail_subject = f'Tu código de activación para JobFlex es {code}'
                message = render_to_string('registration/code_email.html', {
                    'code': code,
                })
                to_email = form.cleaned_data.get('email')
                email = EmailMessage(
                            mail_subject, message, to=[to_email]
                )
                email.send()
                print(f"DEBUG: register_emp - Verification email sent to: {to_email}")
                messages.success(req, "¡Registro exitoso! Por favor, verifica tu correo electrónico para activar tu cuenta.")
                return redirect('verify_code')

            except Exception as e:
                print(f"DEBUG: register_emp - Exception caught during registration: {e}")
                messages.error(req, f"Ocurrió un error durante el registro: {e}")
                return redirect('validate')
        else:
            print(f"DEBUG: register_emp - Form is NOT valid. Errors: {form.errors}")
            # Form is invalid, re-render with errors (template will show them)
            # Need to re-fetch emp_validation for rendering
            try:
                emp_validation = EmpValidation.objects.get(rut_completo=rut)
            except EmpValidation.DoesNotExist:
                # This case should ideally not happen if RUT came from a valid hidden field
                messages.error(req, "Error interno: RUT no encontrado al re-renderizar el formulario.")
                return redirect('validate')

    else: # GET request
        rut_from_get = req.GET.get('rut')
        if not rut_from_get:
            messages.error(req, "No se ha proporcionado un RUT válido para el registro.")
            return redirect('validate')

        try:
            emp_validation = EmpValidation.objects.get(rut_completo=rut_from_get)
        except EmpValidation.DoesNotExist:
            messages.error(req, "El RUT proporcionado no es válido o no fue encontrado.")
            return redirect('validate')
        
        form = CompanyAdminSignUpForm()

    return render(req, 'company/register_emp.html', {
        'form': form,
        'emp_validation': emp_validation
    })

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
def Profile(req):
    return render(req, 'user/profile.html')

@login_required
def user_index(req):
    if hasattr(req.user, 'profile') and req.user.profile.rol == 'empresa':
        return redirect('company_index')
    return render(req, 'user/user_index.html')

def Validate(req):
    if req.method == 'POST':
        rut_input = req.POST.get('rut', '').strip()
        
        # Normalizar el RUT al formato XXXXXXXX-X
        rut_cleaned = rut_input.replace('.', '').upper()
        if '-' in rut_cleaned:
            rut_formatted = rut_cleaned
        elif len(rut_cleaned) > 1:
            rut_formatted = f"{rut_cleaned[:-1]}-{rut_cleaned[-1]}"
        else:
            rut_formatted = rut_cleaned

        try:
            company = EmpValidation.objects.get(rut_completo=rut_formatted)
            return render(req, 'company/validation.html', {'company_found': company})
        except EmpValidation.DoesNotExist:
            error_message = "El RUT ingresado no fue encontrado en nuestros registros."
            return render(req, 'company/validation.html', {'error': error_message})
            
    return render(req, 'company/validation.html')

class CustomPasswordResetConfirmView(auth_views.PasswordResetConfirmView):
    def form_valid(self, form):
        messages.success(self.request, '¡Tu contraseña ha sido actualizada correctamente!')
        return super().form_valid(form)

def social_login_cancelled(request):
    messages.error(request, 'El registro con Google fue cancelado. Por favor, inténtalo de nuevo.')
    return redirect('signup')

@login_required
def create_cv(req):
    return render(req, 'user/create_cv.html')

@login_required
def postulaciones(request):
    return render(request, 'user/postulaciones.html')

def job_offers(request):
		# search = request.GET.get('search', '')
		jobs = Job.objects.all().order_by('-id')
		# if search:
		#     jobs = jobs.filter(title__icontains=search)

		paginator = Paginator(jobs, 5)
		page_number = request.GET.get('page')
		page_obj = paginator.get_page(page_number)

		context = {
				'page_obj': page_obj,
				# 'search': search,
		}

		if request.headers.get('x-requested-with') == 'XMLHttpRequest':
				html = render(request, 'partials/job_list.html', context).content.decode('utf-8')
				return JsonResponse({'html': html})

		return render(request, 'offers/job_offers.html', context)

@login_required
def perfiles_profesionales(request):
    return render(request, 'user/perfiles_profesionales.html')

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
