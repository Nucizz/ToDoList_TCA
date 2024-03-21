    //
    //  AddToDoStore.swift
    //  Blinterns_ToDo_App
    //
    //  Created by Calvin Anacia Suciawan on 01-03-2024.
    //

    import Foundation
    import ComposableArchitecture

    struct ToDoFormReducer: ReducerProtocol {
        
        @Dependency(\.toDoRepository) var toDoRepository
        @Dependency(\.uuid) var uuidRepository
        
        struct State: Equatable {
            var isEditing: Bool = false
            var editedToDoChildValue: AnyToDoModel?
            
            @BindingState var categoryValueField: ToDoCategory
            @BindingState var titleField: String
            @BindingState var descriptionField: String
            @BindingState var deadlineTimeField: Date
            @BindingState var isDeadlineTimeActive: Bool
            
            var shoppingToDoFormState: ShoppingToDoFormReducer.State?
            var travelingToDoFormState: TravelingToDoFormReducer.State?
            var learningToDoFormState: LearningToDoFormReducer.State?
            @PresentationState var alertState: AlertState<Action.AlertAction>?
            
            init(toDo: AnyToDoModel? = nil, category: ToDoCategory? = nil) {
                @Dependency(\.date) var date
                
                if let toDoAttribute = toDo {
                    self.editedToDoChildValue = toDoAttribute
                    self.categoryValueField = toDoAttribute.category
                    self.titleField = toDoAttribute.title
                    self.descriptionField = toDoAttribute.description ?? ""
                    self.deadlineTimeField = toDoAttribute.deadlineTime ?? date.now
                    self.isDeadlineTimeActive = toDoAttribute.deadlineTime == nil ? false : true
                    isEditing = true
                } else {
                    switch category {
                    case .shopping:
                        self.categoryValueField = .shopping
                    case .learning:
                        self.categoryValueField = .learning
                    case .traveling:
                        self.categoryValueField = .learning
                    default:
                        self.categoryValueField = .general
                    }
                    
                    self.titleField = ""
                    self.descriptionField = ""
                    self.deadlineTimeField = date.now
                    self.isDeadlineTimeActive = false
                }
            }
        }
        
        enum Action: BindableAction, Equatable {
            case binding(BindingAction<State>)
            case view(ViewAction)
            case `internal`(InternalAction)
            case external(ExternalAction)
            
            case shoppingToDoFormAction(ShoppingToDoFormReducer.Action)
            case travelingToDoFormAction(TravelingToDoFormReducer.Action)
            case learningToDoFormAction(LearningToDoFormReducer.Action)
            case alertAction(PresentationAction<AlertAction>)
            
            enum ViewAction: Equatable {
                case onCategoryFieldSelected
                case onAddOrEditButtonTapped
            }
            
            enum InternalAction: Equatable {
                case handleAddOrEdit(AnyToDoModel)
            }
            
            enum ExternalAction: Equatable {
                case onToDoAdded(AnyToDoModel)
                case onToDoEdited(AnyToDoModel)
            }
            
            enum AlertAction: Equatable {
                case dismiss
            }
            
        }
        
        var body: some ReducerProtocol<State, Action> {
            BindingReducer()
            
            core
                .self.ifLet(\.shoppingToDoFormState, action: /Action.shoppingToDoFormAction) {
                    ShoppingToDoFormReducer()
                }
                .self.ifLet(\.travelingToDoFormState, action: /Action.travelingToDoFormAction) {
                    TravelingToDoFormReducer()
                }
                .self.ifLet(\.learningToDoFormState, action: /Action.learningToDoFormAction) {
                    LearningToDoFormReducer()
                }
        }
        
    }
