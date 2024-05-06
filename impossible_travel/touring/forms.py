from django import forms
from django.forms import ModelForm
from django.contrib.admin.widgets import AdminDateWidget
from django.forms.fields import DateField
from django.core.exceptions import ValidationError
from django.utils.translation import gettext_lazy as _
import datetime
from .models import Tour

class CreateTourFormUser(ModelForm):

    def date_check(self):
        indate = self.cleaned_data['checkin_date']
        outdate = self.cleaned_data['checkout_date']

        if indate > outdate:
            raise ValidationError(('Дата заезда не может быть позже даты выезда!'))
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
            'checkin_date':AdminDateWidget(),
            'checkout_date':AdminDateWidget(),
        }
    