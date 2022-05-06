import 'package:FisioLago/model/salon.dart';


import 'data.dart';

bool isServiceNotEmptyForSalon(Salon salon, CategoryData item){
  for (var workItem in work)
    if (workItem.categoryId == item.id)
      if (salon.works.contains(workItem.id))
        return true;

    return false;
}