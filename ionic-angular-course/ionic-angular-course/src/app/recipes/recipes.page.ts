import { Component, OnInit } from '@angular/core';
import { RecipesService } from './recipes.service';
import { Recipe } from './recipe.model';

@Component({
  selector: 'app-recipes',
  templateUrl: './recipes.page.html',
  styleUrls: ['./recipes.page.scss'],
})
export class RecipesPage implements OnInit {
  recipes: Recipe[];
  constructor(private recipesService: RecipesService) { }

  ngOnInit() {
    this.recipes = this.recipesService.getAllRecipes();
    console.log(this.recipes);
  }

  // Added this because of a bug on the angular router
  // https://stackoverflow.com/questions/44745354/ngoninit-not-being-called-after-router-navigate
  ionViewWillEnter() {
    this.ngOnInit();
  }
}
