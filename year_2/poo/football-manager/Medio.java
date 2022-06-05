public class Medio extends Player {
    
    private float recuperacao;

    public Medio()
	{
		super();
		this.recuperacao = 0;
	}

	public Medio (String nNome, int nnum,float nremate,float nvelocidade, float nresistencia, float ndestreza, 
    					float nimpulsao, float njogo_cabeca, float ncapac_passe,float nrec){

    	super(nNome, nnum, nremate,nvelocidade,nresistencia,ndestreza,nimpulsao, njogo_cabeca, ncapac_passe);
    	this.recuperacao = nrec;
    }

    public Medio(Medio info){

        super.setNome(info.getNome());
        super.setNumero_jogador(info.getNumero_jogador());
        super.setRemate(info.getRemate());
        super.setVelocidade(info.getVelocidade());
        super.setResistencia(info.getResistencia());
        super.setDestreza(info.getDestreza());
        super.setImpulsao(info.getImpulsao());
        super.setJogo_cabeca(info.getJogo_cabeca());
        super.setCapac_passe(info.getCapac_passe());
        super.setHistorico(info.getHistorico());
        this.setRecu(info.getRecu());
    }

    public static Medio parse(String input){
        String[] campos = input.split(",");
        return new Medio(campos[0], Integer.parseInt(campos[1]),
                Float.parseFloat(campos[2]),
                Float.parseFloat(campos[3]),
                Float.parseFloat(campos[4]),
                Float.parseFloat(campos[5]),
                Float.parseFloat(campos[6]),
                Float.parseFloat(campos[7]),
                Float.parseFloat(campos[8]),
                Float.parseFloat(campos[9]));
    }

    public float getRecu()
    {
    	return this.recuperacao;
    }

    public void setRecu(float nrec)
    {
    	this.recuperacao = nrec;
    }

    /*Calcula o Overall do jogador por media ponderada ,onde os pesos são:
    -----0.400 para o atributo mais imortante
    -----0.250 para o segundo
    -----0.150 para o terceiro
    -----0.100 para o quarto
    -----0.025 para os restantes 
    */

    double overall()
    {
        double nover = 0;

        nover += 0.4   * super.getCapac_passe();
        nover += 0.25  * super.getRemate();
        nover += 0.15  * super.getDestreza();
        nover += 0.1   * this.getRecu();
        nover += 0.025 * super.getVelocidade();
        nover += 0.025 * super.getResistencia();
        nover += 0.025 * super.getImpulsao();
        nover += 0.025 * super.getJogo_cabeca();

        return nover;
    }

    public Player clone()
    {
        return new Medio(this);
    }

}
