class Food {
  final String foodName;
  final int calories;
  final String mealId;
  final String docId;

  Food({ this.foodName, this.calories, this.mealId, this.docId });

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