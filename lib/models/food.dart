class Food {
  final String foodName;
  final int calories;
  final String mealId;

  Food({ this.foodName, this.calories, this.mealId });

  printFoodInfo(){
    if(foodName != null){
      print("Food name is: " + foodName);
    }
  else {
    print("food name is null");
    }
  }
  getName(){
    return foodName;
  }

  getCalories(){
    return calories;
  }

  getMealId(){
    return mealId;
  }
}