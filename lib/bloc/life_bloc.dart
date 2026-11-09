import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/life_repository.dart';
import '../domain/models.dart';
import 'life_event.dart';
import 'life_state.dart';

export 'life_event.dart';
export 'life_state.dart';

class LifeBloc extends Bloc<LifeEvent, LifeState> {
  LifeBloc(this.repository) : super(LifeState()) {
    // ประมวลผลตามลำดับ ป้องกันผลลัพธ์เก่าทับข้อมูลใหม่
    on<LifeEvent>(_handle, transformer: sequential());
  }

  final LifeRepository repository;

  Future<void> _handle(LifeEvent event, Emitter<LifeState> emit) async {
    if (event is LanguageChanged) {
      emit(state.copyWith(language: event.language));
      return;
    }

    if (event is CurrencyChanged) {
      emit(state.copyWith(currency: event.currency));
      return;
    }

    final isLoad = event is LifeLoaded;

    emit(
      state.copyWith(
        loading: isLoad && state.data.entries.isEmpty,
        saving: !isLoad,
      ),
    );

    try {
      final LifeSnapshot data;

      if (event is EntrySaved) {
        data = await repository.save(event.entry);
      } else if (event is EntryRemoved) {
        data = await repository.remove(event.id);
      } else if (event is TaskToggled) {
        data = await repository.toggleTask(event.id);
      } else if (event is BillPaid) {
        data = await repository.payBill(event.id);
      } else {
        data = await repository.load();
      }

      emit(state.copyWith(data: data, loading: false, saving: false));
    } catch (_) {
      emit(
        state.copyWith(
          loading: false,
          saving: false,
          error: switch (state.language) {
            'lo' => 'ດຳເນີນການບໍ່ສຳເລັດ ກະລຸນາລອງໃໝ່',
            'en' => 'Could not complete the action. Please try again.',
            'zh' => '操作未能完成，请重试。',
            _ => 'ดำเนินการไม่สำเร็จ กรุณาลองอีกครั้ง',
          },
        ),
      );
    }
  }
}
