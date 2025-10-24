from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.contrib.auth.models import User
from .models import Company, CompanyMembership, CompanyInvitation, UserProfile, EmpValidation,Ability,Job,JobCategory

# Define an inline admin descriptor for UserProfile
class UserProfileInline(admin.StackedInline):
    model = UserProfile
    can_delete = False
    verbose_name_plural = 'profile'

# Define a new User admin
class UserAdmin(BaseUserAdmin):
    inlines = (UserProfileInline,)

# Re-register UserAdmin
admin.site.unregister(User)
admin.site.register(User, UserAdmin)

class CompanyMembershipInline(admin.TabularInline):
    model = CompanyMembership
    extra = 1

@admin.register(Company)
class CompanyAdmin(admin.ModelAdmin):
    list_display = ('name', 'industry', 'location')
    inlines = (CompanyMembershipInline,)

@admin.register(CompanyInvitation)
class CompanyInvitationAdmin(admin.ModelAdmin):
    list_display = ('email', 'company', 'role', 'status', 'created_at')
    list_filter = ('status', 'company')

@admin.register(EmpValidation)
class EmpValidationAdmin(admin.ModelAdmin):
    search_fields = ('razon_social', 'rut_completo')

admin.site.register(CompanyMembership)

admin.site.register(Ability)
admin.site.register(Job)
admin.site.register(JobCategory)
