import Foundation
import SwiftUI

struct TransactionEntryView: View {
    @StateObject var viewModel = TransactionEntryViewModel()
    @FocusState var isNumberPadActive: Bool
    
    var body: some View {
        VStack {
            Picker("", selection: $viewModel.isSpend) {
                Text("Expense").tag(true)
                Text("Income").tag(false)
            }
            .pickerStyle(.segmented)
            .onChange(of: viewModel.isSpend) { isSpend in
                if !isSpend, !viewModel.payWithBank, let firstBank = viewModel.availableBanks.first {
                    viewModel.payWithBank = true
                    viewModel.bank = firstBank
                    viewModel.checkCurrencyChanged(newCurrency: firstBank.currency)
                }
            }
            
            HStack {
                Text("Date")
                
                DatePicker(selection: $viewModel.date, in: ...Date.now, displayedComponents: .date) {
                    Text(viewModel.date.formatted(date: .long, time: .omitted))
                }
            }
            
            HStack {
                Text("Notes")
                
                TextField("information on the transaction", text: $viewModel.notes)
            }
            
            HStack {
                Text("Amount")
                
                Text(viewModel.currency.symbol)
                
                TextField(viewModel.currency == .yen ? "0" : "0.00", text: $viewModel.amount)
                    .keyboardType(viewModel.currency == .yen ? .numberPad : .decimalPad)
                    .focused($isNumberPadActive)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()

                            Button("Done") {
                                isNumberPadActive = false
                            }
                        }
                    }
            }
            
            if viewModel.isSpend {
                Picker("", selection: $viewModel.payWithBank) {
                    Text("Bank").tag(true)
                    Text("Credit Card").tag(false)
                }
                .pickerStyle(.segmented)
                .onChange(of: viewModel.payWithBank) { payWithBank in
                    if payWithBank {
                        if let bank = viewModel.availableBanks.first {
                            viewModel.bank = bank
                            viewModel.checkCurrencyChanged(newCurrency: bank.currency)
                        }
                    } else {
                        if let card = viewModel.availableCreditCards.first {
                            viewModel.creditCard = card
                            viewModel.checkCurrencyChanged(newCurrency: card.currency)
                        }
                    }
                }
            }
                
            HStack {
                Text(viewModel.isSpend ? "Using:" : "Deposit to:")
                
                if viewModel.payWithBank {
                    Picker("No saved banks", selection: $viewModel.bank) {
                        ForEach(viewModel.availableBanks, id: \.id) { bank in
                            Text(bank.name).tag(bank)
                        }
                    }
                    .onChange(of: viewModel.bank) { bank in
                        viewModel.checkCurrencyChanged(newCurrency: bank.currency)
                    }
                } else {
                    Picker("No saved credit cards", selection: $viewModel.creditCard) {
                        ForEach(viewModel.availableCreditCards, id: \.id) { card in
                            Text(card.name).tag(card)
                        }
                    }
                    .onChange(of: viewModel.creditCard) { card in
                        viewModel.checkCurrencyChanged(newCurrency: card.currency)
                    }
                }
            }
            
            Spacer().frame(height: 80)
            
            HStack {
                Text("Category")
                    
                Spacer()
            }
            
            LazyVGrid(columns: viewModel.categoryColumns, spacing: 10) {
                if viewModel.isSpend {
                    ForEach(viewModel.availableExpenseCategories, id: \.name) { category in
                        Button {
                            viewModel.expenseCategory = ExpenseCategoryType.init(rawValue: category.name)
                        } label: {
                            VStack {
                                Image(category.imageName)
                                
                                Text(category.name)
                            }
                            .border(category.name == (viewModel.expenseCategory?.rawValue ?? "") ? .gray : .clear, width: 2)
                        }
                    }
                } else {
                    ForEach(viewModel.availableIncomeCategories, id: \.name) { category in
                        Button {
                            viewModel.incomeCategory = IncomeCategoryType.init(rawValue: category.name)
                        } label: {
                            VStack {
                                Image(category.imageName)
                                
                                Text(category.name)
                            }
                            .border(category.name == (viewModel.incomeCategory?.rawValue ?? "") ? .gray : .clear, width: 2)
                        }
                    }
                }
            }
            
            Button("Submit") {
                viewModel.showingAlert = true
            }
            .padding()
            .background(.orange)
            .clipShape(Capsule())
        }
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(title: Text("Submit entry?"),
                primaryButton: .default(Text("Yes"), action: {
                    viewModel.submit()
                }),
                secondaryButton: .destructive(Text("cancel")))
        }
        .alert("Error", isPresented: $viewModel.showingError) {
            Button("OK", role: .cancel) {}
        }
        .onAppear {
            viewModel.resetBanksAndCardsData()
        }
    }
}
