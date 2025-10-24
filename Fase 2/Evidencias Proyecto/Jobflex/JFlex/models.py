from django.db import models
from django.contrib.auth.models import User
import uuid
# Create your models here.


class EmpValidation(models.Model):
    """
    Modelo para almacenar la validación de empresas a partir del archivo del SII.
    """

    id = models.BigAutoField(primary_key=True)
    rut = models.IntegerField()
    dv = models.CharField(max_length=1)
    rut_completo = models.CharField(max_length=12, unique=True, db_index=True)
    razon_social = models.CharField(max_length=255, db_index=True)

    def __str__(self):
        return f"{self.razon_social} ({self.rut_completo})"


# --- NUEVOS MODELOS ---


class UserProfile(models.Model):
    """
    Extiende el modelo User de Django para añadir un rol global.
    """

    ROLE_CHOICES = (
        ("usuario", "Usuario"),
        ("empresa", "Empresa"),
    )
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="profile")
    rol = models.CharField(max_length=20, choices=ROLE_CHOICES, default="usuario")

    def __str__(self):
        return f"{self.user.username} - {self.get_rol_display()}"


class Company(models.Model):
    """
    Almacena el perfil y la información detallada de una empresa.
    """

    # Conexión con la empresa validada por RUT
    validation = models.OneToOneField(
        EmpValidation, on_delete=models.CASCADE, related_name="profile"
    )

    # Atributos del perfil extraídos de tu HTML
    name = models.CharField(max_length=255, help_text="Nombre comercial de la empresa")
    logo = models.ImageField(upload_to="company_logos/", null=True, blank=True)
    banner = models.ImageField(upload_to="company_banners/", null=True, blank=True)
    tagline = models.CharField(
        max_length=255,
        null=True,
        blank=True,
        help_text="Ej: Software y Servicios de TI • 1,200 empleados",
    )
    mission = models.TextField(
        null=True, blank=True, help_text="La misión de la empresa"
    )
    culture = models.TextField(
        null=True, blank=True, help_text="Descripción de la cultura y valores"
    )
    website = models.URLField(max_length=200, null=True, blank=True)
    industry = models.CharField(max_length=100, null=True, blank=True)
    location = models.CharField(max_length=255, null=True, blank=True)
    year_founded = models.PositiveIntegerField(null=True, blank=True)

    # Relación para obtener los miembros/empleados de la empresa
    members = models.ManyToManyField(
        User, through="CompanyMembership", related_name="companies"
    )

    def __str__(self):
        return self.name


class CompanyMembership(models.Model):
    """
    Tabla puente para gestionar los roles de los usuarios dentro de las empresas.
    """

    ROLE_CHOICES = (
        ("admin", "Administrador"),
        ("employee", "Empleado"),
    )
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    company = models.ForeignKey(Company, on_delete=models.CASCADE)
    role = models.CharField(max_length=20, choices=ROLE_CHOICES)

    class Meta:
        unique_together = (
            "user",
            "company",
        )  # Un usuario no puede tener dos roles en la misma empresa

    def __str__(self):
        return (
            f"{self.user.username} es {self.get_role_display()} en {self.company.name}"
        )


class CompanyInvitation(models.Model):
    """
    Almacena las invitaciones enviadas por los administradores de empresas a nuevos usuarios.
    """

    STATUS_CHOICES = (
        ("pending", "Pendiente"),
        ("accepted", "Aceptada"),
    )

    company = models.ForeignKey(
        Company, on_delete=models.CASCADE, related_name="invitations"
    )
    email = models.EmailField()
    role = models.CharField(
        max_length=20, choices=CompanyMembership.ROLE_CHOICES, default="employee"
    )
    token = models.UUIDField(default=uuid.uuid4, editable=False, unique=True)
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default="pending")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Invitación para {self.email} a {self.company.name}"

class JobCategory(models.Model):
		"""Categorías para las ofertas de trabajo (Ej: 'Tecnología', 'Marketing')."""
		name = models.CharField(max_length=100, unique=True)

		def __str__(self):
				return self.name

class Ability(models.Model):
		COLOR_CHOICES=(
				("gray","Gris"),
				("red","Rojo"),
				("orange","Naranja"),
				("yellow","Amarillo"),
				("green","Verde"),
				("teal","Verde Azulado"),
				("blue","Azul"),
				("indigo","Azul Marino"),
				("purple","Morado"),
				("pink","Rosa"),
		)
		name = models.CharField(max_length=255)
		color = models.CharField(max_length=50,choices=COLOR_CHOICES,default="gray")
		
		def __str__(self):
				return self.name

class Job(models.Model):
		"""
		Ofertas de trabajo
		"""
		STATUS_CHOICES = (
				('active', 'Activa'),
				('paused', 'En Pausa'),
				('closed', 'Cerrada'),
		)
		MODE_CHOICES = (
				("hybrid", "Hibrido"),
				("remote", "Remoto"),
				("in-person", "Presencial"),
		)
		LVL_CHOICES = (
				("senior", "Senior"),
				("mid-sen", "Mid-Senior"),
				("jun-mid", "Junior-Mid"),
				("junior", "Junior"),
		)

		company = models.ForeignKey(Company, on_delete=models.CASCADE)
		posted_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, help_text="Usuario de la empresa que publicó la oferta")

		name = models.CharField(
				max_length=200, help_text="Nombre del empleo/posicion ofrecida"
		)
		description= models.TextField(max_length=500)
		requirements = models.JSONField(default=list, blank=True)
		
		mode = models.CharField(max_length=20, choices=MODE_CHOICES)
		level = models.CharField(max_length=20, choices=LVL_CHOICES)
		place = models.CharField(max_length=100, blank=True, null=True)
		salary = models.CharField(max_length=255, null=True, blank=True, help_text="Ej: $1.000.000 - $1.500.000 CLP")
		
		category = models.ForeignKey(JobCategory, on_delete=models.SET_NULL, null=True, related_name='job_offers')
		status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='active')

		Time_start = models.TimeField()
		Time_end = models.TimeField()
		
		abilities = models.ManyToManyField(Ability)
		
		created_at = models.DateTimeField(auto_now_add=True)
		
		def get_mode_display_with_place(self):
				base_display = self.get_mode_display()
				if self.place and self.mode in ("hybrid", "in-person"):
						return f"{base_display} - {self.place}"
				return base_display

		def __str__(self):
				return f"{self.company.name} - {self.name}"
