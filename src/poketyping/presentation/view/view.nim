import ../../application/typing_usecase

type
  GameView* = ref object
    viewModel*: GameViewModel

  GameViewModel* = ref object
    status*: string
    useCase*: TypingUseCase
    view*: GameView
