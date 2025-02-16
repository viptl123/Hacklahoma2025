import SwiftUI
struct StatisticsPage: View {
    
    @State private var totalSteps: Int = 0
    
    @State private var dailyStepGoal: Int = 10000
    
    @State private var weeklySteps: [Int] = Array(repeating: 0, count: 7) // Initial empty week
    
    
    
    var averageDailySteps: Int {
        
        weeklySteps.reduce(0, +) / weeklySteps.count
        
    }
    
    
    
    var progressPercentage: Double {
        
        min(Double(totalSteps) / Double(dailyStepGoal), 1.0)
        
    }
    
    
    
    var totalScreenTime: Int {
        
        totalSteps / 1000 * 60
        
    }
    
    
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 20) {
                
                // Title
                
                Text("Statistics")
                
                    .font(.largeTitle)
                
                    .bold()
                
                    .padding()
                
                
                
                // Editable total steps for today
                
                HStack {
                    
                    Text("Total Steps Today:")
                    
                        .font(.title2)
                    
                    Spacer()
                    
                    TextField("Enter steps", value: $totalSteps, formatter: NumberFormatter())
                    
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                        .keyboardType(.numberPad)
                    
                        .frame(width: 100)
                    
                }
                
                .padding(.horizontal)
                
                
                
                // Progress bar
                
                VStack(alignment: .leading) {
                    
                    Text("Daily Step Goal: \(dailyStepGoal)")
                    
                        .font(.headline)
                    
                    
                    
                    ProgressView(value: progressPercentage)
                    
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                    
                        .padding(.vertical)
                    
                }
                
                .padding(.horizontal)
                
                
                
                // Button to change step goal
                
                Button(action: {
                    
                    changeDailyStepGoal()
                    
                }) {
                    
                    Text("Change Daily Step Goal")
                    
                        .frame(maxWidth: .infinity)
                    
                        .padding()
                    
                        .background(Color.blue)
                    
                        .foregroundColor(.white)
                    
                        .cornerRadius(10)
                    
                        .padding(.horizontal)
                    
                }
                
                
                
                // Weekly trend input
                
                VStack(alignment: .leading) {
                    
                    Text("Edit Weekly Steps")
                    
                        .font(.headline)
                    
                        .padding(.bottom, 10)
                    
                    
                    
                    // Editable fields for each day's steps
                    
                    ForEach(0..<weeklySteps.count, id: \.self) { index in
                        
                        HStack {
                            
                            Text("Day \(index + 1)")
                            
                            Spacer()
                            
                            TextField("Enter steps", value: $weeklySteps[index], formatter: NumberFormatter())
                            
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                                .keyboardType(.numberPad)
                            
                                .frame(width: 100)
                            
                        }
                        
                    }
                    
                }
                
                .padding(.horizontal)
                
                
                
                // Average daily steps
                
                HStack {
                    
                    Text("Average Daily Steps:")
                    
                        .font(.title2)
                    
                    Spacer()
                    
                    Text("\(averageDailySteps)")
                    
                        .font(.title2)
                    
                        .bold()
                    
                }
                
                .padding(.horizontal)
                
                
                
                // Total screen time earned
                
                HStack {
                    
                    Text("Screen Time Earned:")
                    
                        .font(.title2)
                    
                    Spacer()
                    
                    Text("\(totalScreenTime) minutes")
                    
                        .font(.title2)
                    
                        .bold()
                    
                }
                
                .padding(.horizontal)
                
            }
            
            .padding()
            
        }
        
    }
    
    func changeDailyStepGoal() {

          let possibleGoals = [5000, 10000, 15000, 20000]

          if let currentIndex = possibleGoals.firstIndex(of: dailyStepGoal) {

              dailyStepGoal = possibleGoals[(currentIndex + 1) % possibleGoals.count]

          }

      }

  }
