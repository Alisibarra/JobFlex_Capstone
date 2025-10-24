from django.urls import path, include
from django.views.generic.base import RedirectView
from . import views, Company_views
from django.contrib.auth import views as auth_views

urlpatterns = [
    path("", views.index, name="index"),
    path("signup/", views.signup, name="signup"),
    path('register/', views.signup, name='register'),
    path("register_emp/", views.register_emp, name="register_emp"),
    path('verify_code/', views.verify_code, name='verify_code'),
    path("validate/", views.Validate, name="validate"),
    path('profile/', views.Profile, name='profile'),
    path('user_index/', views.user_index, name='user_index'),
    path('create-cv/', views.create_cv, name='create_cv'),
    path('applications/', views.postulaciones, name='postulaciones'),
    path('perfiles-profesionales/', views.perfiles_profesionales, name='perfiles_profesionales'),
    path('offers/', views.job_offers, name='job_offers'),
    path('company-profile/', Company_views.company_profile, name='company_profile'),
    path('company/onboarding/', Company_views.company_onboarding_wizard, name='company_onboarding_wizard'),
    path('company/users/', Company_views.company_users, name='company_users'),
    path('company/invitations/', Company_views.company_invitations, name='company_invitations'),
    path('company/createJob/', Company_views.job_create, name='newjob'),
    path('company/Job/<int:id>', Company_views.job_detail, name='job_detail'),

    path('login/', auth_views.LoginView.as_view(template_name='registration/login.html'), name='login'),
    path('logout/', auth_views.LogoutView.as_view(), name='logout'),

    path('password_reset/', auth_views.PasswordResetView.as_view(template_name='registration/forgot_password.html'), name='password_reset'),
    path('password_reset/done/', auth_views.PasswordResetDoneView.as_view(template_name='registration/password_reset_done.html'), name='password_reset_done'),
    path('reset/<uidb64>/<token>/', views.CustomPasswordResetConfirmView.as_view(template_name='registration/reset_password.html'), name='password_reset_confirm'),
    path('reset/done/', RedirectView.as_view(pattern_name='login'), name='password_reset_complete'),
    path('company_index/', Company_views.company_index, name='company_index'),
]