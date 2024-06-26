import datetime

from django import forms
from django.forms import ModelForm
from django.core.exceptions import ValidationError
from django.utils.translation import gettext_lazy as _
from django.contrib.auth.models import User
from django.contrib.auth.forms import UserCreationForm

from .models import Tour, Profile

class EmailInput(forms.EmailInput):
    """
    Класс для подключения виджета
    """
    input_type = 'email'


class DateInput(forms.DateInput):
    """
    Класс для подключения виджета
    """
    input_type = 'date'


class CreateTourFormUser(ModelForm):
    """
    Форма для создания тура пользователем
    """
    # Функции для автоматического сохранения имени пользователя в соответствующем поле
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
        fields = ['hotel', 'checkin_date', 'checkout_date', 'entertaiments']

        labels = {'hotel':_('Выберите гостиницу'), 
                  'checkin_date':_('Дата заезда'), 
                  'checkout_date':_('Дата выезда'), 
                  'entertaiments':_('Выберите варианты досуга'), 
                  }
        help_texts = {'hotel':_(''), 
                      'checkin_date':_(''), 
                      'checkout_date':_(''), 
                      'entertaiments':_(''), 
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
    """
    Форма для регистрации нового пользователя
    """
    
    class Meta:
        model = User
        
        fields = ['username', 'email', 'password1', 'password2']

        labels = {
                    'username': _('Имя пользователя'), 
                    'email': _('Адрес электронной почты'), 
                    'password1': _('Придумайте пароль'), 
                    'password2': _('Повторите пароль'), 
                }
        
        help_texts = {
                        'username':_(''), 
                        'email':_(''), 
                        'password1':_(''), 
                        'password2':_(''), 
                    }
        widgets = {
                        'email': EmailInput
                }

    def save(self, commit=True):
        user = super(NewUserForm, self).save(commit=False)
        user.email = self.cleaned_data['email']
        if commit:
            user.save()
        return user


class UserEditForm(forms.ModelForm):
    """
    Изменение содержимого полей модели User
    """
    class Meta:
        model = User
        fields = ['first_name', 'last_name', 'email']

        labels = {
                    'first_name': _('Имя'), 
                    'last_name': _('Фамилия'), 
                    'email': _('Email'), 
                }
        
        widgets = {
            'email':EmailInput
        }


class ProfileEditForm(forms.ModelForm):
    """
    Изменение содержимого полей модели Profile
    """

    class Meta:
        model = Profile
        fields = ('date_of_birth', 'photo')

        labels = {
            'date_of_birth':_('Дата рождения'),
            'photo': _('Фото профиля')    
        }

        widgets = {
            'date_of_birth': DateInput
        }


class CreateTourFormStaff(ModelForm):
    """
    Форма для создания тура персоналом для клиента
    """
        
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
        fields = ['tourist' ,'hotel', 'checkin_date', 'checkout_date', 'entertaiments']

        labels = {'tourist':_('Выберите пользователя'),
                  'hotel':_('Выберите гостиницу'), 
                  'checkin_date':_('Дата заезда'), 
                  'checkout_date':_('Дата выезда'), 
                  'entertaiments':_('Выберите варианты досуга'), 
                  }
        help_texts = {'hotel':_(''), 
                      'checkin_date':_(''), 
                      'checkout_date':_(''), 
                      'entertaiments':_(''), 
                      }
        widgets = {
            'checkin_date':DateInput(),
            'checkout_date':DateInput(),
        }
        initial = {
            'checkin_date': datetime.date.today(),
            'chackout_date': datetime.date.today(),
        }