
class DifferentTypes < ArgumentError; end

class ValidateFail < StandardError; end
class WrongManufaturer < StandardError; end


class InvalidVan < ValidateFail; end
class NotEnoughFreeVolume < InvalidVan; end
class NotEnoughFreeSeats < InvalidVan; end
class VanDoubleHooked < InvalidVan; end
class VanNotHooked < InvalidVan; end
class WrongVanNumber < InvalidVan; end

class InvalidTrain < ValidateFail; end
class TrainMoving < InvalidTrain; end
class WrongTrainNumber < InvalidTrain; end

class InvalidStation < ValidateFail; end
class InvalidStationName < InvalidStation; end

class InvalidRoute < ValidateFail; end
