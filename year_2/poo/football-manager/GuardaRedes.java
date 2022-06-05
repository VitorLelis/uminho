public class GuardaRedes extends Player {

	private float elasticidade;

	public GuardaRedes(){
		super();
		this.elasticidade = 0;
	}
    
    public GuardaRedes (String nNome, int nnum,float nremate,float nvelocidade, float nresistencia, float ndestreza, 
    float nimpulsao, float njogo_cabeca, float ncapac_passe,float nelast){

    	super(nNome, nnum, nremate, nvelocidade, nresistencia,ndestreza,nimpulsao, njogo_cabeca, ncapac_passe);
    	this.elasticidade = nelast;
    }

    public GuardaRedes(GuardaRedes info){

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
        this.setElast(info.getElast());
    }

    public static GuardaRedes parse(String input){
        String[] campos = input.split(",");
        return new GuardaRedes(campos[0], Integer.parseInt(campos[1]),
                Float.parseFloat(campos[2]),
                Float.parseFloat(campos[3]),
                Float.parseFloat(campos[4]),
                Float.parseFloat(campos[5]),
                Float.parseFloat(campos[6]),
                Float.parseFloat(campos[7]),
                Float.parseFloat(campos[8]),
                Float.parseFloat(campos[9]));
    }

    public float getElast()
    {
    	return this.elasticidade;
    }

    public void setElast(float nelast)
    {
    	this.elasticidade = nelast;
    }


    double overall()
    {
        double nover = 0;

     	nover += 0.4   * this.getElast();
        nover += 0.25  * super.getResistencia();
        nover += 0.15  * super.getCapac_passe();
        nover += 0.1   * super.getVelocidade();
        nover += 0.025 * super.getRemate();
        nover += 0.025 * super.getDestreza();
        nover += 0.025 * super.getImpulsao();
        nover += 0.025 * super.getJogo_cabeca();

     	return nover;
    }

    public Player clone()
    {
        return new GuardaRedes(this);
    }

}
