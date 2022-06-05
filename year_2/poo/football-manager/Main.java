import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

public class Main{
    public static void main(String[] args){
        //Titulo do jogo 
        System.out.println("+---------------------------+\n\nwelcome to football manager!\n\n+---------------------------+\n");
    
        int option;
        String origin;
        Scanner sc = new Scanner(System.in);

        System.out.println("\nComo deseja carregar as Informações?\n(0)->Estado de Jogo já salvo\n(1)->Arquivo de texto\n");
        option = sc.nextInt();
        sc.nextLine(); //Mover o cursor do leitor para apos o \n

        System.out.println("\nDigite o nome (Se necessário, o caminho também): ");
        origin = sc.nextLine();

        /** Lê o Estado do Jogo */
        Equipas eq = new Equipas();

        if(option == 0)
        {
            try{
                try {
                    eq = eq.readObject(origin);
                } catch (IOException e) {
                    System.out.println(e.getMessage());
    
                    }
                }
                catch(ClassNotFoundException classnot){
                    System.out.println(classnot.getMessage() + ", Erro na leitura da classe");
            }
        }

        /* Opção de ler do arquivo principal e gravar o estado*/
        
        else{
            LoadFile lf = new LoadFile();
            try{
              eq = lf.parse(origin); 
            } 
            catch(LinhaIncorretaException|ReadException ex){
                System.out.println(ex.getMessage() + " Linha incorreta / leu incorretamente\n");
             }
            
                 
            try{
                eq.saveBinary("estadoJogo.txt");
            }
            catch(IOException e){
                System.out.println(e.getMessage() + " ,Erro na tentativa de gravar o estado do jogo");
            }
        }
        
        
        /** Realização do Menu Principal / Jogo */

        int op = 0; // opcao de sáida
        Menu m = new Menu();
        while(op != -1){ 
            op = m.menuPrincipal(); 
            if(op != 4){
                switch(op){
                    case 1:
                        String teamName = m.menuTimes(eq);
                        Team time = eq.getElenco(teamName);
                        m.showJogadores(time);
                        op = m.menuFinal();
                        break;
                    case 2:
                        m.execTransfer(eq);
                        op = m.menuFinal();
                        break;
                    case 3:
                        m.showHistory(eq);
                        op = m.menuFinal();
                        break;
                    default: break;             
                }
            }
        }
        System.out.println("\nAté a próxima!\n");
    }
}
