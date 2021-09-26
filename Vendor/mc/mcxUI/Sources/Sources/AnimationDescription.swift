import Foundation

class AnimationDescription {

   private var animations: [() -> Void] = []
   private var completions: [(Bool) -> Void] = []

   func addAnimation(_ animation: @escaping () -> Void) {
      animations.append(animation)
   }

   func addCompletion(_ completion: @escaping (Bool) -> Void) {
      completions.append(completion)
   }

   func runAnimations() {
      animations.forEach { $0() }
   }

   func runCompletions(isCompleted: Bool) {
      completions.forEach { $0(isCompleted) }
   }

   func runAll() {
      runAnimations()
      runCompletions(isCompleted: true)
   }
}
