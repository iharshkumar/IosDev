import Cocoa
import CreateML
import Foundation

let trainingUrl = URL(fileURLWithPath: "/Users/batch02l1/Desktop/DataSet/Training")
let testUrl = URL(fileURLWithPath: "/Users/batch02l1/Desktop/DataSet/Testing")
print("Training Started")

let model = try MLImageClassifier(trainingData: .labeledDirectories(at: trainingUrl))

print("Training In Progress")

let evaluation=model.evaluation(on: .labeledDirectories(at: testUrl))

print("test completed")

try model.write(to: URL(fileURLWithPath: "/Users/batch02l1/Desktop/DataSet/Cat&DogClassifier.mlmodel"))

