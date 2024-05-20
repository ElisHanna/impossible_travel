from django.test import TestCase
from django.urls import reverse

from .models import Direction

class DirectionModelTest(TestCase):

    @classmethod
    def setUpTestData(cls):
        Direction.objects.create(name='DreamLand', description='FarFarAway')

    def test_name_label(self):
        direction = Direction.objects.get(id=1)
        field_label = direction._meta.get_field('name').verbose_name
        self.assertEquals(field_label, 'name')
    
    def test_description_label(self):
        direction = Direction.objects.get(id=1)
        field_label = direction._meta.get_field('description').verbose_name
        self.assertEquals(field_label, 'description')

    def test_name_max_length(self):
        direction = Direction.objects.get(id=1)
        max_length = direction._meta.get_field('name').max_length
        self.assertEquals(max_length, 50)
    
    def test_description_max_length(self):
        direction = Direction.objects.get(id=1)
        max_length = direction._meta.get_field('description').max_length
        self.assertEquals(max_length, 500)
    
    def test_get_absolute_url(self):
        direction = Direction.objects.get(id=1)
        self.assertEquals(direction.get_absolute_url(), '/touring/direction/1')


class DirectionListViewTest(TestCase):

    @classmethod
    def setUpTestData(cls):
        number_of_directions = 15
        for direction_num in range(number_of_directions):
            Direction.objects.create(name='Landia %s' %direction_num, description = 'FarFarAway %s' %direction_num,)

    def test_view_url_exists_at_desired_location(self):
        resp = self.client.get('/touring/directions/')
        self.assertEqual(resp.status_code, 200)

    def test_view_url_accessible_by_name(self):
        resp = self.client.get(reverse('directions'))
        self.assertEqual(resp.status_code, 200)

        self.assertTemplateUsed(resp, 'touring/direction_list.html')

    def pagination_is_tvelve(self):
        resp = self.client.get(reverse('directions'))
        self.assertEqual(resp.status_code, 200)
        self.assertTrue('is_paginated' in resp.context)
        self.assertTrue(resp.context['is_paginated']==True)
        self.assertTrue(len(resp.context['direction_list'])==12)

    def test_test_lists_all_directions(self):
        resp = self.client.get(reverse('directions')+'?page=2')
        self.assertEqual(resp.status_code, 200)
        self.assertTrue('is_paginated' in resp.context)
        self.assertTrue(resp.context['is_paginated']==True)
        self.assertTrue(len(resp.context['direction_list'])==3)
        
        

    