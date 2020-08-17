

  String getEstadoPostulacion(String numEstado){
    switch(numEstado){
      case "0":{ return "En revición";   }    break;
      case "1":{ return "Aprobado";      }    break;
      case "2":{ return "Rechazado";     }    break;
      default: {return "Estado invalido";}    break;

    }
  }

