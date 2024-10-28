import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Time "mo:base/Time";

actor {
  type WorkoutId = Nat;
  
  type Workout = {
    id: WorkoutId;
    workoutType: Text;
    duration: Nat; // in minutes
    caloriesBurned: Nat;
    date: Time.Time;
  };

  var workouts = Buffer.Buffer<Workout>(0);

  public func recordWorkout(workoutType: Text, duration: Nat, caloriesBurned: Nat) : async WorkoutId {
    let workoutId = workouts.size();
    let newWorkout: Workout = {
      id = workoutId;
      workoutType = workoutType;
      duration = duration;
      caloriesBurned = caloriesBurned;
      date = Time.now();
    };
    workouts.add(newWorkout);
    workoutId
  };

  public query func getWorkout(workoutId: WorkoutId) : async ?Workout {
    if (workoutId < workouts.size()) {
      ?workouts.get(workoutId);
    } else {
      null;
    };
  };

  public query func getAllWorkouts() : async [Workout] {
    Buffer.toArray(workouts)
  };

  public query func getWorkoutsByType(workoutType: Text) : async [Workout] {
    let results = Buffer.Buffer<Workout>(0);
    for (workout in workouts.vals()) {
      if (Text.equal(workout.workoutType, workoutType)) {
        results.add(workout);
      };
    };
    Buffer.toArray(results)
  };
}