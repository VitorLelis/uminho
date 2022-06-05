import java.util.InputMismatchException;
import java.util.Scanner;

public class Menu {

    /** Mostra o menu principal e ler a opção do usuario*/
    
    public int menuPrincipal(){
        int opcao = -1;
        showMenuPrincipal();
        while(opcao == -1){
            opcao = lerOpcaoMenu(4);
        }
        if(opcao == 4) opcao = -1;
        return opcao;
    }

    public void showMenuPrincipal(){
        StringBuilder sb = new StringBuilder();
        
        sb.append("\n *** Menu Principal de Jogo *** \n\n")
        .append("*Opções:\n")
        .append("-> 1. Ver os times do jogo\n")
        .append("-> 2. Fazer uma transferência\n")
        .append("-> 3. Ver o Histórico de times de um jogador\n")
        .append("-> 4. Sair do Jogo\n\n");

        System.out.println(sb.toString());
    }


    public int lerOpcaoMenu(int nopcoes){
        int op;
        Scanner is = new Scanner(System.in);
        
        System.out.print("Opção: ");
        try {
            op = is.nextInt();
        }
        catch (InputMismatchException e) { // Não foi inscrito um int
            op = -1;
        }
        if (op<=0 || op > nopcoes) {
            System.out.println("Opção Inválida!!!");
            op = -1;
        }
        return op;
    }

    //-------------------------------------------

    /** Opção 1 */

    public String menuTimes(Equipas eq){
        showtimes(eq);
        String time = "";
        while(time.equals("")){
            time = lerTime(eq);
        }
        return time;

    }




    public void showtimes(Equipas eq){
        StringBuilder sb = new StringBuilder();
        sb.append("\n *** Lista de times do Jogo *** \n\n");
        for( String t : eq.getNomes()){
            sb.append("."+t+"\n");
        }
        sb.append("\n");
        System.out.println(sb.toString());
    }
    
    public String lerTime(Equipas eq){
        String op;
        Scanner is = new Scanner(System.in);
        
        System.out.print("Digite um time: ");
        op = is.nextLine();
        if(eq.existeTime(op) == 0){
            op = "";
            System.out.println("Este time não existe, tente novamente\n");
        } 
        
        return op;
    }


    public int menuFinal(){
        int op = -1;
        System.out.println("\n\nDeseja fazer o que agora??\n");
        System.out.println("1 -> Voltar para o menu principal\n");
        System.out.println("2 -> Sair do jogo\n");
        while(op == -1){
            op = lerOpcaoMenu(2);
        }
        if(op == 2) op = -1; 
        return op;
    }    

    public void showJogadores(Team t){
        StringBuilder sb = new StringBuilder();
        sb.append("\n *** Elenco: *** \n\n");
        sb.append("*Overall da equipa: " + String.format("%.0f", t.getTeamOverall()) + "\n\n");
        for (Player p : t.getSetPlayers()){
            sb.append("| " + p.getNome() + " ( " + p.getNumero_jogador() + " )    Overall: " + String.format("%.0f",p.overall()) + "\n");
        }
        System.out.println(sb.toString());
    }

    //--------------------------------------------------------

    /** Opção 2 */

    public void execTransfer(Equipas eq){
        Team t = new Team();
        String nome = "";
        Scanner is = new Scanner(System.in);
        while(t.getNome_time().equals("")){ // Pede um jogador ao usuário e devolve o time que ele está inserido
            System.out.println("Digite o nome do jogador que quer fazer transferancia: ");
            nome = is.nextLine();
            t = eq.searchPlayer(nome);
            if(t.getNome_time().equals("")){
                System.out.println(nome + " não está em nenhum time, por favor digite um jogador válido\n");
            }
        }
        Player p = t.getPlayer(nome);
        int oldShirt = p.getNumero_jogador();
        String oldTeam = t.getNome_time();
        int flag = 0;
        String newTeam = "";
        while(flag == 0){ // Realizar a transferência do jogador para um clube que o usuário queira
            System.out.println("\nDigite um time para transferencia: ");
            newTeam = is.nextLine();
            try{
                eq.transfer(p, oldTeam , newTeam);
                flag++;
            }
            catch(TransferError e){
                System.out.println(e.getMessage() + "Incorreto, insira um time correto");
            }
        }

        StringBuilder sb = new StringBuilder();
        sb.append("\n\n--Transferencia realizada do(a) craque " + nome + "--\n\n")
            .append("Clube antigo: "+ oldTeam + "\n")
            .append("Numero de camisa antigo: "+ oldShirt+"\n\n")
            .append("Novo time: " + newTeam + "\n")
            .append("Camisa que irá utilizar: " + p.getNumero_jogador() + "\n");
        
        System.out.println(sb.toString());


        
    }

     
    /*-----------------------------------------*/

    /*Opcao 3*/

    public void showHistory(Equipas eq){

    Scanner is = new Scanner(System.in);
    
    System.out.println("Digite o nome do jogador que deseja o Histórico: ");
    
    String p = is.nextLine();

    StringBuilder sb = new StringBuilder();
       
   try{
        sb.append("\n"+(eq.searchPlayer(p).getPlayer(p).history()));}

    catch(Exception e){
        sb.append("\n"+p+" não existe!");}

    System.out.println(sb.toString());

    }
}
