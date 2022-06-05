import java.io.*;
import java.util.*;
import java.util.stream.Collectors;
import java.util.Map;
import java.util.HashMap;
import java.util.Iterator;

public class Team implements Serializable{
    
    /** INSTANCE VARIABLES*/
    
    private Map <String,Player> jogadores;
    private double team_overall;
    private String nome_time;
    
    /** -----------------------------------------------*/
    /** CONSTRUCTORS */

    public Team(){
        this.jogadores = new HashMap<>();
        this.team_overall = 0; 
        this.nome_time = "";
    }
   
    public Team(Map<Integer,Player>players,String time){
        this.jogadores = new HashMap<>();
        this.team_overall = 0;
        
        int i = 0;
        for(Player j : players.values()){
            i++;
            this.jogadores.put(j.getNome(),j.clone());
            this.team_overall +=  j.overall();
        }

        this.team_overall /= i;
        this.nome_time = time;
     }
    
     public Team(Team t){
         this.jogadores = t.getPlayers();
         this.team_overall = t.getTeamOverall();
         this.nome_time = t.getNome_time();
     }

    public Team(String s){
        this.jogadores = new HashMap<>();
        this.team_overall = 0; 
        this.nome_time = s;
     }

    /** -----------------------------------------------*/
    /** GETTERS AND SETERS */ 

    public String getNome_time(){
        return this.nome_time;
    }
    public void setNome_time(String name)
    {
        this.nome_time = name;
    }

    public double getTeamOverall(){
        return this.team_overall;
    }

    public void setOverall(float ovr){
        this.team_overall = ovr;
    }

    public Map <String,Player> getPlayers(){
        Map<String,Player> time = new HashMap<>();
        for(Player j : this.jogadores.values()){
            time.put(j.getNome(),j.clone());
        }
        return time;
    }

    public Player getPlayer(String nome){
        return this.jogadores.get(nome).clone();
    }

    public Collection<Player> getSetPlayers(){
        return this.jogadores.values();
    }
    
    /*---------------------------------------------------*/

    /*Recalcula o Overall do time*/
    public void recalcOverall()
    {
        int size = this.jogadores.size();
       
        double soma = 0;
        for (Player j : this.jogadores.values())
            soma += j.overall();

        if (soma != 0) this.team_overall = soma/size;
        else this.team_overall = 0.0;
    }

    /*Função para garantir que o jogador possui uma camisa valida no time*/
    public void checkShirt(Player p)
    {
        ArrayList<Integer> lst = new ArrayList<>();
        for(Player pl : this.jogadores.values())
            lst.add(pl.getNumero_jogador());

        while(lst.contains(p.getNumero_jogador()))
        {
            int number = (int) (Math.random() * 100);
            p.setNumero_jogador(number);
        }

    }

    // Função que verifica se o nome do jogador já existe
    
    public boolean existeNome(String nome){
        return this.jogadores.containsKey(nome);
    }
    
    
    /*Função para incrementar o time com um novo jogador*/
    public void addPlayer_time(Player p) throws JogadorExisteException{
        if (this.jogadores.containsKey(p.getNome()))
            throw new JogadorExisteException(p.getNome());
        else
        {
            this.checkShirt(p);
            p.setHistorico(p.getHistorico()+this.getNome_time()+"\n");
            this.jogadores.put(p.getNome(),p.clone());
            this.recalcOverall();
        }
    }

    /*Função para remover um determinado jogador do time*/
    public void removePlayer_time(Player p) throws NoPlayerException
    {
        if (this.jogadores.containsKey(p.getNome()))
        {
            this.jogadores.remove(p.getNome());
            this.recalcOverall();
        }

        else
            throw new NoPlayerException(p.getNome());
        
    }


    

    /*Função clone*/
    public Team clone()
    {
        return new Team(this);
    }

    /*----------------------------------------------------------------------------------*/
    
}
