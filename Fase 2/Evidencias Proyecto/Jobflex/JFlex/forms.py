from django import forms
from django.utils.translation import gettext_lazy as _
from allauth.account.forms import LoginForm
from django.contrib.auth import get_user_model
from django.contrib.auth.forms import UserCreationForm
import uuid
import json
from .models import Company, CompanyInvitation, CompanyMembership, Job # Import the models

User = get_user_model()

class CustomLoginForm(LoginForm):
    def clean(self):
        cleaned_data = super().clean()
        email = self.cleaned_data.get('login')
        password = self.cleaned_data.get('password')

        if email and password:
            try:
                user = User.objects.get(email=email)
                if user.socialaccount_set.exists():
                    # Si el usuario tiene cuentas sociales, no debería poder loguearse con contraseña
                    raise forms.ValidationError(
                        _("Esta cuenta se registró usando un proveedor externo (como Google). Por favor, inicia sesión usando ese método.")
                    )
            except User.DoesNotExist:
                # Dejar que el manejador de login normal muestre el error de "usuario no existe"
                pass
        
        return cleaned_data

class SignUpForm(UserCreationForm):
    full_name = forms.CharField(max_length=150, required=True, label='Nombre Completo')
    email = forms.EmailField(max_length=254, required=True, label='Correo Electrónico')

    class Meta:
        model = User
        fields = ('full_name', 'email')

    def __init__(self, *args, **kwargs):
        super(SignUpForm, self).__init__(*args, **kwargs)
        self.fields['password1'].label = "Contraseña"
        self.fields['password2'].label = "Confirmar Contraseña"
        self.fields['password1'].help_text = None
        self.fields['password2'].help_text = None

        for field_name in self.fields:
            field = self.fields.get(field_name)
            if field:
                field.widget.attrs.update({
                    'class': 'mt-1 block w-full p-3 border border-light-gray rounded-lg focus:outline-none focus:ring-2 focus:ring-primary'
                })

    def save(self, commit=True):
        user = super(SignUpForm, self).save(commit=False)
        user.username = str(uuid.uuid4())
        print(f"DEBUG: SignUpForm - Generated username: {user.username}")
        full_name = self.cleaned_data['full_name']
        parts = full_name.split(' ', 1)
        user.first_name = parts[0]
        if len(parts) > 1:
            user.last_name = parts[1]
        else:
            user.last_name = ''
        if commit:
            user.save()
        return user

class CompanyAdminSignUpForm(SignUpForm):
    nombre_comercial = forms.CharField(max_length=255, required=True, label="Nombre Comercial")
    full_name = forms.CharField(max_length=150, required=True, label='Nombre Completo de Representante') # Override label

    class Meta(SignUpForm.Meta):
        fields = ('nombre_comercial', 'full_name', 'email')

    def __init__(self, *args, **kwargs):
        super(CompanyAdminSignUpForm, self).__init__(*args, **kwargs)
        # Actualizar placeholder o atributos si es necesario para el nuevo campo
        self.fields['nombre_comercial'].widget.attrs.update({
            'class': 'mt-1 block w-full pt-6 pb-3 px-3 border border-light-gray rounded-lg focus:outline-none focus:ring-2 focus:ring-primary peer',
            'placeholder': ' '
        })
        # Ensure full_name also gets the correct styling
        self.fields['full_name'].widget.attrs.update({
            'class': 'mt-1 block w-full pt-6 pb-3 px-3 border border-light-gray rounded-lg focus:outline-none focus:ring-2 focus:ring-primary peer',
            'placeholder': ' '
        })

    def save(self, commit=True):
        user = super(SignUpForm, self).save(commit=False)
        user.username = user.email # Set username to email for company admins
        full_name = self.cleaned_data['full_name']
        parts = full_name.split(' ', 1)
        user.first_name = parts[0]
        if len(parts) > 1:
            user.last_name = parts[1]
        else:
            user.last_name = ''
        if commit:
            user.save()
        return user
class VerificationForm(forms.Form):
    code = forms.CharField(max_length=6, required=True, label="Código de Verificación")

# --- Company Onboarding Forms ---

class CompanyBasicInfoForm(forms.ModelForm):
    class Meta:
        model = Company
        fields = ['tagline', 'industry', 'location', 'year_founded', 'website']
        widgets = {
            'tagline': forms.TextInput(attrs={'placeholder': 'Ej: Software y Servicios de TI • 1,200 empleados'}),
            'industry': forms.TextInput(attrs={'placeholder': 'Ej: Tecnología, Marketing, Finanzas'}),
            'location': forms.TextInput(attrs={'placeholder': 'Ej: Santiago, Chile (Remoto)'}),
            'website': forms.URLInput(attrs={'placeholder': 'https://www.tuempresa.com'}),
        }

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        for field_name in self.fields:
            field = self.fields.get(field_name)
            if field:
                field.widget.attrs.update({
                    'class': 'mt-1 block w-full pt-6 pb-3 px-3 border border-light-gray rounded-lg focus:outline-none focus:ring-2 focus:ring-primary peer',
                    'placeholder': field.widget.attrs.get('placeholder', ' ') # Keep existing placeholder or set default
                })

class CompanyDescriptionForm(forms.ModelForm):
    class Meta:
        model = Company
        fields = ['mission', 'culture']
        widgets = {
            'mission': forms.Textarea(attrs={'rows': 4, 'placeholder': 'Describe la misión de tu empresa...'}),
            'culture': forms.Textarea(attrs={'rows': 4, 'placeholder': 'Describe la cultura y valores de tu empresa...'}),
        }

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        for field_name in self.fields:
            field = self.fields.get(field_name)
            if field:
                field.widget.attrs.update({
                    'class': 'mt-1 block w-full pt-6 pb-3 px-3 border border-light-gray rounded-lg focus:outline-none focus:ring-2 focus:ring-primary peer',
                    'placeholder': field.widget.attrs.get('placeholder', ' ')
                })

class CompanyBrandingForm(forms.ModelForm):
    class Meta:
        model = Company
        fields = ['logo', 'banner']

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        for field_name in self.fields:
            field = self.fields.get(field_name)
            if field:
                field.widget.attrs.update({
                    'class': 'mt-1 block w-full pt-6 pb-3 px-3 border border-light-gray rounded-lg focus:outline-none focus:ring-2 focus:ring-primary peer',
                })

class CompanyInvitationForm(forms.ModelForm):
    class Meta:
        model = CompanyInvitation
        fields = ['email', 'role']
        widgets = {
            'email': forms.EmailInput(attrs={'placeholder': 'ejemplo@tuempresa.com'}),
            'role': forms.Select(),
        }

class CompanyMemberRoleForm(forms.ModelForm):
    class Meta:
        model = CompanyMembership
        fields = ['role']
        widgets = {
            'role': forms.Select(attrs={'class': 'mt-1 block w-full p-3 border border-light-gray rounded-lg focus:outline-none focus:ring-2 focus:ring-primary'}),
        }

# --- Job Offers ---

class JobForm(forms.ModelForm):
    # Hidden JSON field for dynamic requirements (handled by JS)
    requirements_data = forms.CharField(widget=forms.HiddenInput())

    class Meta:
        model = Job
        exclude = ('company','requirements','posted_by')
        widgets = {
            "name": forms.TextInput(attrs={"class": "border border-gray-300 rounded-lg p-2 w-full"}),
            "mode": forms.Select(attrs={"class": "border border-gray-300 rounded-lg p-2 w-full"}),
            "level": forms.Select(attrs={"class": "border border-gray-300 rounded-lg p-2 w-full"}),
						"status": forms.Select(attrs={"class": "border border-gray-300 rounded-lg p-2 w-full"}),
            "category": forms.Select(attrs={"class": "border border-gray-300 rounded-lg p-2 w-full"}),
            "place": forms.TextInput(attrs={"class": "border border-gray-300 rounded-lg p-2 w-full"}),
            "salary": forms.TextInput(attrs={"class": "border border-gray-300 rounded-lg p-2 w-full"}),
            "Time_start": forms.TimeInput(attrs={"type": "time", "class": "border border-gray-300 rounded-lg p-2 w-full"}),
            "Time_end": forms.TimeInput(attrs={"type": "time", "class": "border border-gray-300 rounded-lg p-2 w-full"}),
            "abilities": forms.SelectMultiple(attrs={"class": "border border-gray-300 rounded-lg p-2 w-full"}),
            "description": forms.TextInput(attrs={"class": "border border-gray-300 rounded-lg p-2 w-full"}),
        }
        labels = {
            'name': 'Nombre del puesto',
            'description': 'Descripción',
            'salary': 'Salario',
            'mode': 'Modalidad',
            'level': 'Nivel',
            'palce': 'Lugar',
            'Time_start': 'Hora inicio',
            'Time_end': 'Hora fin',
            'abilities': 'Abilidades',
        }

    def clean(self):
        cleaned_data = super().clean()
        req_data = cleaned_data.get("requirements_data", "[]")
        try:
            cleaned_data["requirements"] = json.loads(req_data)
        except json.JSONDecodeError:
            cleaned_data["requirements"] = []
        return cleaned_data