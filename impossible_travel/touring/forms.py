from typing import Any, Mapping
from django import forms
from django.core.files.base import File
from django.db.models.base import Model
from django.forms import ModelForm
from django.core.exceptions import ValidationError
from django.forms.utils import ErrorList
from django.utils.translation import gettext_lazy as _
from datetime import date
from .models import Tour
from django.contrib.auth.models import User

class DateInput(forms.DateInput):
    input_type = 'date'

class CreateTourFormUser(ModelForm):
    
    def __init__(self, user_info, *args, **kwargs):
        self.user_info = user_info
        super().__init__(*args, **kwargs)

    def save(self, *args, **kwargs):
        self.instance.tourist = self.user_info
        return super().save(*args, **kwargs)
    
    def date_check(self):
        indate = self.cleaned_data['checkin_date']
        outdate = self.cleaned_data['checkout_date']

        if indate > outdate:
            raise ValidationError(_('Дата заезда не может быть позже даты выезда!'))
        
        if indate < date.today() or outdate < date.today():
            raise ValidationError(_('Даты заезда и выезда не могут быть в прошлом!'))
        
        return indate, outdate
    
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
            'checkin_date': date.today(),
            'chackout_date': date.today(),
        }
    