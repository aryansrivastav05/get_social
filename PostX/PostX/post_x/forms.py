from django import forms
from .models import Post 
from django.contrib.auth.models import User
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.models import User 


class PostForm(forms.ModelForm):
    class Meta:
        model = Post
        fields = ['text', 'photo']
        widgets = {
            'text': forms.Textarea(attrs={'rows': 4, 'cols': 40, 'placeholder': 'What\'s on your mind?'}),
        }

class UserRegistrationForm(UserCreationForm):
    class Meta:
        model = User
        fields = ['username', 'email', 'password1', 'password2']
   