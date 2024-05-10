# from typing import Any, Mapping
from django import forms
# from django.core.files.base import File
# from django.db.models.base import Model
from django.forms import ModelForm
from django.core.exceptions import ValidationError
# from django.forms.utils import ErrorList
from django.utils.translation import gettext_lazy as _
import datetime
from .models import Tour
from django.contrib.auth.models import User
from django.contrib.auth.forms import UserCreationForm

class DateInput(forms.DateInput):
    input_type = 'date'

class CreateTourFormUser(ModelForm):
    
    def __init__(self, user_info, *args, **kwargs):
        self.user_info = user_info
        super().__init__(*args, **kwargs)

    def save(self, *args, **kwargs):
        self.instance.tourist = self.user_info
        return super().save(*args, **kwargs)
    
    def clean(self):
        cleaned_data = super().clean()
        checkin_date = cleaned_data['checkin_date']
        checkout_date = cleaned_data['checkout_date']

        if checkin_date > checkout_date:
            raise ValidationError(_('Дата заезда не может быть позже даты выезда!'))
        
        if checkin_date < datetime.date.today():
            raise ValidationError(_('Дата заезда и выезда не может быть в прошлом!'))
        
        if checkout_date < datetime.date.today():
            raise ValidationError(_('Дата заезда и выезда не может быть в прошлом!'))
        
    class Meta:
        model = Tour
        fields = ['hotel', 'checkin_date', 'checkout_date', 'entertaiments', 'cost']

        labels = {'hotel':_('Выберите гостиницу'), 
                  'checkin_date':_('Дата заезда'), 
                  'checkout_date':_('Дата выезда'), 
                  'entertaiments':_('Выберите варианты досуга'), 
                  'cost':_('Итоговая стоимость'),
                  }
        help_texts = {'hotel':_(''), 
                      'checkin_date':_(''), 
                      'checkout_date':_(''), 
                      'entertaiments':_(''), 
                      'cost':_ ('')
                      }
        widgets = {
            'checkin_date':DateInput(),
            'checkout_date':DateInput(),
        }
        initial = {
            'checkin_date': datetime.date.today(),
            'chackout_date': datetime.date.today(),
        }
    
class NewUserForm(UserCreationForm):
    email = forms.EmailField(required=True)

    class Meta:
        model = User
        fields = ('username', 'email', 'password1', 'password2')

        labels = {'username':_('Имя пользователя'), 
                  'email':_('Адрес электронной почты'), 
                  'password1':_('Придумайте пароль'), 
                  'password2':_('Повторите пароль'), 
                  }
        help_texts = {'username':_('Имя пользователя'), 
                    'email':_('Адрес электронной почты'), 
                    'password1':_('Придумайте пароль'), 
                    'password2':_('Повторите пароль'), 
                      }

    def save(self, commit=True):
        user = super(NewUserForm, self).save(commit=False)
        user.email = self.cleaned_data['email']
        if commit:
            user.save()
        return user