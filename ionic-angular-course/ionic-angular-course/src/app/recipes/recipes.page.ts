import { Component, OnInit } from '@angular/core';

import { Recipe } from './recipe.model';

@Component({
  selector: 'app-recipes',
  templateUrl: './recipes.page.html',
  styleUrls: ['./recipes.page.scss'],
})
export class RecipesPage implements OnInit {

  recipes: Recipe[] = [
    {
      id: 'r1',
      title: 'Schnitzel',
      imageUrl: 'https://loremflickr.com/640/360',
      ingredients: ['French Fries', 'Tofu', 'Salad']
    },
    {
      id: 'r2',
      title: 'Spaghetti',
      imageUrl: 'https://loremflickr.com/640/360',
      ingredients: ['Spaghetti', 'Vegan cheese', 'Tomatico']
    }
  ];

  constructor() { }

  ngOnInit() {
  }

}
