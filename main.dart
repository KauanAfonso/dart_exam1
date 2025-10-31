
import 'dart:io';

/* Funções */

void show_welcome_message(String? name){
    print("\n-------------Olá $name,seja bem vindo! Ao Kauan Lava-Rápido-------------\n");
}

//mostrar menu
void show_menu(){
  print("Digite 01 - Basic Lavagem - 40 Reais");
  print("Digite 02 - Standart Lavagem - 60 reais");
  print("Digite 03 - Preimum Lavagem - 80 reais ");
  print("Digite 04 - Para sair e ir para pagamento!");
}

//validar data
String validate_data(String? variable_string){
//validação
while(variable_string == null || variable_string.trim().isEmpty){ //trim ignora os espaços
    print('Existem dados vazios ou nulo, tente novamente:');
    variable_string = stdin.readLineSync();
}
    return variable_string;
}

//calcular o total 
dynamic calc_total(dynamic shop_cart_array){

    double acummulate_total = 0;
    shop_cart_array.forEach((product){
        acummulate_total += product['total'];
    });

    return acummulate_total;

}

//mostrar o menu de pagamento
void show_payment_menu(){
  print("Digite 01 - Pix");
  print("Digite 02 - Cartão de crétito");
  print("Digite 03 - Cartão de débito");
  print("Digite 04 - Dinheiro ");
  print("Digite 05 - Para cancelar serviço");
}


//mostrar a nota fiscal final ao cliente
void show_invoice(dynamic shop_cart_array, double full_total, String client_name , String client_id, int option, double change){
  
    print("-------------------------------------------");
    print("Nota fiscal de $client_name");
    print("Documento presente na nota: $client_id");

    print("Sua compra foi: ");
    shop_cart_array.forEach((product){
        print(" O serviço de lavagem de carro foi o ${product['service_name']} - com o valor unitário de ${product['price']} - total de ${product['total']}");
    });

    print('O total do(s) serviços foram de $full_total reais');
    

    if(option == 1){
      print("Pago com Pix");
    }else if(option == 2){
      print("Pago com Cartão de crédito");
    }else if(option == 3){
      print("Oago com cartão de débito");
    }else{
      print("Pago em dinheiro, troco de $change reais");
    }
}


/* Codigo principal */

void main(){


//database 
Map<String, dynamic> basic = {'id': 1, 'service_name' : "Basic", "price": 40.00}; 
Map<String, dynamic> standart = {'id': 2, 'service_name' : "standart", "price": 50.00}; 
Map<String, dynamic> preimum = {'id': 3, 'service_name' : "preimum", "price": 80.00}; 
List<dynamic> products = [basic,standart, preimum];

//Escolha do cliente
Map<String, dynamic> chose = {'service_name' : "", "price": 0 , "quantity": 0, "total": 0}; 

//Carrinho que irá receber as escolhas do cliente
List<dynamic> shop_cart = [];

int? quantity = 0;
int? option;
double total_price;


print("Digite seu nome:");
String? client_name = stdin.readLineSync();
client_name = validate_data(client_name);

print("Digite o seu documento: ");
String? client_id = stdin.readLineSync();
client_id = validate_data(client_id);

//Lógica para ele adicionar produtos no carrinho
do {
  try{
    show_welcome_message(client_name);
    show_menu();
    option = int.parse(stdin.readLineSync()!);
    
    if(option == 4){
      print("Você escolheu sair...");
      break;
    }

    print("Qual a quantidade do serviço selecionado? ");
    quantity = int.parse(stdin.readLineSync()!);

    switch(option){
      case 1:
        chose['service_name'] = products[0]["service_name"];
        chose['price'] = products[0]['price'];
        chose['quantity'] = quantity;
        chose['total'] = products[0]['price'] * quantity;
        shop_cart.add(chose);    
        break;
      
      case 2:
        chose['service_name'] = products[1]["service_name"];
        chose['price'] = products[1]['price'];
        chose['quantity'] = quantity;
        chose['total'] = products[1]['price'] * quantity;
        shop_cart.add(chose);
        break;

      case 3:
        chose['service_name'] = products[2]["service_name"];
        chose['price'] = products[2]['price'];
        chose['quantity'] = quantity;
        chose['total'] = products[2]['price'] * quantity;
        shop_cart.add(chose);
        break;

      default:
        print("Opção inválida"); 
    }
  }catch(e){
    print("Digite corretamente!!");
  }
} while (option!= 4);


total_price = calc_total(shop_cart);

print("Você tem um total a pagar de: $total_price");

//variaveis para o controle do preço final
double change = 0;
double discounted_price = 0;
double full_total = total_price;
bool condition = false;



//Logica de pagamento
while(!condition){
  try{
   show_payment_menu();
   option = int.parse(stdin.readLineSync()!);

  if(option == 5){
      print("Você escolheu cancelar o serviço...");
      condition = true;
      break;
  }

  switch(option){
    case 1:
      discounted_price = total_price * 0.10;
      print("Total: ${total_price - discounted_price} reais com 10% de desconto no pix");
      break;

    case 2:
      print("Total: ${total_price} reais ");
      print("Quantas vezes será parcelado? (10 % de juros)");
      int parcellament = int.parse(stdin.readLineSync()!);
      discounted_price = total_price * 0.10;
      full_total = total_price + discounted_price;
      print("Total: ${full_total} reais com 10% de juros - em $parcellament vezes de ${full_total / parcellament} ");
      break;


    case 3:
      discounted_price = total_price * 0.5;
      full_total = total_price - discounted_price;
      print("Total: ${full_total} reais com 5% de desconto com opção de cartão de débito");
      break;
    
    case 4:
      print("Total: ${total_price} reais ");
      print("Quanto em dinheiro você pagará esse(s) serviço?");
      double money = double.parse(stdin.readLineSync()!);
      while(money < total_price){
          print("Está faltando dinheiro!");
          print("Quanto em dinheiro você pagará esse(s) serviço?");
          money = double.parse(stdin.readLineSync()!);
      }

      if(money == total_price){
        change = 0;
      }else{
        change = money - total_price;
        print("Seu troco deverá ser de $change reais");
      }
      break;
    
    default:
      print("Não aceitamos esse tipo de pagamento");

  }
  show_invoice(shop_cart, full_total, client_name, client_id, option, change);
  condition = true;
  }catch(e){
    print("Digite corretamente !");
  }
  
} 

}