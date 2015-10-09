// Вычисляет минимум и максимум входного N-мерного массива
FilterNumbers {

  function filter(num,acc) {
    if (isnan(acc.min)) acc.min = 10000000;
    if (isnan(acc.max)) acc.max = -10000000;

    if (acc.max < num) acc.max = num;
    if (acc.min > num) acc.min = num;
  }
  
  property var min: output.min
  property var max: output.max
  property var diff: max-min

}