DifferentTypes = Class.new(ArgumentError)

ValidateFail = Class.new(StandardError)
WrongManufaturer = Class.new(StandardError)

InvalidVan = Class.new(ValidateFail)
NotEnoughFreeVolume = Class.new(InvalidVan)
NotEnoughFreeSeats = Class.new(InvalidVan)
VanDoubleHooked = Class.new(InvalidVan)
VanNotHooked = Class.new(InvalidVan)
WrongVanNumber = Class.new(InvalidVan)

InvalidTrain = Class.new(ValidateFail)
TrainMoving = Class.new(InvalidTrain)
WrongTrainNumber = Class.new(InvalidTrain)

InvalidStation = Class.new(ValidateFail)
InvalidStationName = Class.new(InvalidStation)

InvalidRoute = Class.new(ValidateFail)
