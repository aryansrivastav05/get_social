from django.urls import path
from . import views
from django.contrib.auth import views as auth_views

urlpatterns = [
    # Show the post list on the site root
    path('', views.post_list, name='post_list'),
    # keep the original index view available at /home/
    path('home/', views.index, name='index'),
    path('create/', views.post_create, name='post_create'),
    # include trailing slashes for consistency
    path('<int:post_id>/edit/', views.post_edit, name='post_edit'),
    path('<int:post_id>/delete/', views.post_delete, name='post_delete'),
    path('register/', views.register, name='register'),
    path('accounts/login/', auth_views.LoginView.as_view(), name='login'),
    path('accounts/logout/', auth_views.LogoutView.as_view(), name='logout'),
    ]
