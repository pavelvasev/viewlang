// Вычисляет минимум и максимум ... но это долго... get и set каждый раз
FilterNumbers {

  function reset() {
    min = 1e10;
    max = -1e10;
  }

  function add(num) {
    if (max < num) max = num;
    if (min > num) min = num;
  }
  
  property var min
  property var max
  property var diff: max-min

}