import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/meals_provider.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FilterProvider extends StateNotifier<Map<Filter, bool>> {
  FilterProvider()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarian: false,
          Filter.vegan: false,
        });

  void setFilters(Map<Filter, bool> filters) {
    state = filters;
  }

  void setFilter(Filter filter, bool value) {
    state = {
      ...state,
      filter: value,
    };
  }
}

final filterProvider = StateNotifierProvider<FilterProvider, Map<Filter, bool>>(
    (ref) => FilterProvider());

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final selectedFilters = ref.watch(filterProvider);
  return meals.where((meal) {
    if (selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }

    if (selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }

    if (selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }

    if (selectedFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }

    return true;
  }).toList();
});
