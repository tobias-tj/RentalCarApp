part of 'create_car_bloc.dart';

sealed class CreateCarEvent extends Equatable {
  const CreateCarEvent();

  @override
  List<Object> get props => [];
}

class CreateCarRequired extends CreateCarEvent {
  final File imageFile;
  final String carId;
  final String name;
  final String cv;
  final String transmission;
  final String people;
  final String priceDay;
  final String engine;
  final String type;

  const CreateCarRequired(this.imageFile, this.carId, this.name, this.cv,
      this.transmission, this.people, this.priceDay, this.engine, this.type);

  @override
  List<Object> get props => [
        imageFile,
        carId,
        name,
        cv,
        transmission,
        people,
        priceDay,
        engine,
        type
      ];
}
