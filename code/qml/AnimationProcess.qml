/*
  Анимационные процессы позволят
  * вести несколько аним. процессов одновременно
  * сохранять их значения в параметрах
  * задавать аним. процессы программно (и управлять ими программно?)
    типа записали мультик, получили сигнал что он отрендерен, дали сигнал на сохранение на сервер, запустили след. анимацию

  плюс
  * делать нелинейные процессы
  * визуализировать их на таймлайне

  Plan

  gather all AP
  each AP have values: length, start-time
  manager have 3 actions
  
  start
  perform
  finished

  on each action it calls all AP's.
  on start he may determine total length, to understand when loop will be finished

  have loop number. if increases when finished occurs.

  finished occurs after last perform, which is calculated as max{length}.
  
  on each of signals MovieRecorder connects and makes recordings.

  AnimationProcess is a base. Maybe better to have ParamAnimationProcess, which's target is determined by param path.
*/


Item {
  id: ap
  property var enabled: true

  property var target: parent
  property var property: "value"
  property var propertyWrite: property
//  property var name

  property var min: 0
  property var max: 100
  property var step: 1

  AnimationTick {
    enabled: ap.enabled
    onAction: perform();
  }

  function perform() {
    target[propertyWrite] = target[property] + step;
    if ( (step > 0 && target[property] >= max) || ((step < 0 && target[property] <= min))) {
    }
  
  }
  
}
