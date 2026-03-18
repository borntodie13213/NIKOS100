
////! Aqui estao todos os endpoints e o q deve ser mandando, e o q recebe (em casos q tem algo para receber)
////! Idealmente marcar um dia pra ir no escritorio antes de implementar para tirar duvidas etc

/*
letraBtn(
    letra: "T",
    cor: Colors.brown,
    tooltip: "bolao_login",
    onPressed: () async {
    final resp = await serverPost(
        "bolao_login",
        myJson: {
        "cgccpf": "12345678901",
        "nascimento": "09/09/2009",
        },
    );
    print(resp);
    // {"Response":"[{\"cpf\":12345678901,\"max_palpites\":25}]"}
    },
),
const SizedBox(width: 8),
letraBtn(
    letra: "E",
    cor: Colors.green,
    tooltip: "bolao_salva_palpite",
    onPressed: () async {
    await serverPost(
        "bolao_salva_palpite",
        myJson: {
        "cgccpf": "12345678901", // Nao criei token para esse caso, entao simplesmente toda requisicao de editar palpite, mande o cpf e data de nascimento, q devera ficar armzenado em uma var global para poder ser reutilizado
        "nascimento": "09/09/2009",
        "idjogo": "1",
        "palpaa": "1",
        "palpbb": "1",
        },
    );
    },
),
const SizedBox(width: 8),
letraBtn(
    letra: "R",
    cor: Colors.pink,
    tooltip: "adm_bolao_salva_jogos",
    onPressed: () async {
    await serverPost(
        "adm_bolao_salva_jogos",
        myJson: {
        "idjogo": "1",
        "datjog": "31/12/2026 20:30",
        "timeaa": "Time A",
        "siglaa": "TMA",
        "siglbb": "TMB",
        "timebb": "Time B",
        "plcraa": "1", // Ou valor (sempre como string) ex: "2"
        "plcrbb": "1", // Ou valor (sempre como string) ex: "2"
        },
    );
    },
),
const SizedBox(width: 8),
letraBtn(
    letra: "L",
    cor: Colors.cyan,
    tooltip: "bolao_get_jogos",
    onPressed: () async {
    final resp = await serverPost("bolao_get_jogos");
    print(resp);
    // {"Response":"[{\"datalt\":\"2026-03-17 21:45:34\",\"datjog\":\"2026-11-20 13:00:00\",\"idjogo\":1,\"plcraa\":0,\"plcrbb\":2,\"siglaa\":\"QAT\",\"siglbb\":\"ECU\",\"timeaa\":\"CATAR\",\"timebb\":\"EQUADOR\",\"usualt\":\"411\"},{\"datalt\":\"2026-03-17 21:45:34\",\"datjog\":\"2026-11-21 10:00:00\",\"idjogo\":2,\"plcraa\":6,\"plcrbb\":2,\"siglaa\":\"ENG\",\"siglbb\":\"IRN\",\"timeaa\":\"INGLATERRA\",\"timebb\":\"IRA\",\"usualt\":\"411\"},{\"datalt\":\"2026-03-17 21:45:34\",\"datjog\":\"2026-11-22 13:00:00\",\"idjogo\":3,\"plcraa\":1,\"plcrbb\":2,\"siglaa\":\"ARG\",\"siglbb\":\"KSA\",\"timeaa\":\"ARGENTINA\",\"timebb\":\"ARABIA SAUDITA\",\"usualt\":\"411\"},{\"datalt\":\"2026-03-17 21:45:34\",\"datjog\":\"2026-11-23 16:00:00\",\"idjogo\":4,\"plcraa\":1,\"plcrbb\":2,\"siglaa\":\"GER\",\"siglbb\":\"JPN\",\"timeaa\":\"ALEMANHA\",\"timebb\":\"JAPAO\",\"usualt\":\"411\"},{\"datalt\":\"2026-03-17 21:45:34\",\"datjog\":\"2026-11-24 16:00:00\",\"idjogo\":5,\"plcraa\":2,\"plcrbb\":0,\"siglaa\":\"BRA\",\"siglbb\":\"SRB\",\"timeaa\":\"BRASIL\",\"timebb\":\"SERVIA\",\"usualt\":\"411\"},{\"datalt\":\"2026-03-17 21:45:34\",\"datjog\":\"2026-11-25 13:00:00\",\"idjogo\":6,\"plcraa\":3,\"plcrbb\":2,\"siglaa\":\"POR\",\"siglbb\":\"GHA\",\"timeaa\":\"PORTUGAL\",\"timebb\":\"GANA\",\"usualt\":\"411\"},{\"datalt\":\"2026-03-17 21:45:34\",\"datjog\":\"2026-11-26 10:00:00\",\"idjogo\":7,\"plcraa\":2,\"plcrbb\":1,\"siglaa\":\"FRA\",\"siglbb\":\"DEN\",\"timeaa\":\"FRANCA\",\"timebb\":\"DINAMARCA\",\"usualt\":\"411\"},{\"datalt\":\"2026-03-17 21:45:34\",\"datjog\":\"2026-11-27 16:00:00\",\"idjogo\":8,\"plcraa\":1,\"plcrbb\":1,\"siglaa\":\"ESP\",\"siglbb\":\"CRO\",\"timeaa\":\"ESPANHA\",\"timebb\":\"CROACIA\",\"usualt\":\"411\"},{\"datalt\":\"2026-03-17 21:45:34\",\"datjog\":\"2026-11-28 13:00:00\",\"idjogo\":9,\"plcraa\":2,\"plcrbb\":1,\"siglaa\":\"NED\",\"siglbb\":\"USA\",\"timeaa\":\"HOLANDA\",\"timebb\":\"ESTADOS UNIDOS\",\"usualt\":\"411\"},{\"datalt\":\"2026-03-17 21:45:34\",\"datjog\":\"2026-11-29 16:00:00\",\"idjogo\":10,\"plcraa\":2,\"plcrbb\":0,\"siglaa\":\"MAR\",\"siglbb\":\"BEL\",\"timeaa\":\"MARROCOS\",\"timebb\":\"BELGICA\",\"usualt\":\"411\"}]"}
    // datalt e usualt sao inuteism ignore
    },
),
const SizedBox(width: 8),
letraBtn(
    letra: "E",
    cor: Colors.deepOrange,
    tooltip: "bolao_rank",
    onPressed: () async {
    final resp = await serverPost(
        "bolao_rank",
        myJson: {
        "cgccpf": "12345678901",
        },
    );
    print(resp);
    // {"Response":"[{\"cgccpf\":\"80000000006\",\"pontos\":14.0,\"posicao\":1.0},{\"cgccpf\":\"80000000012\",\"pontos\":14.0,\"posicao\":2.0},{\"cgccpf\":\"80000000018\",\"pontos\":14.0,\"posicao\":3.0},{\"cgccpf\":\"05764104971\",\"pontos\":13.0,\"posicao\":4.0},{\"cgccpf\":\"04687894992\",\"pontos\":11.0,\"posicao\":5.0},{\"cgccpf\":\"80000000003\",\"pontos\":10.0,\"posicao\":6.0},{\"cgccpf\":\"80000000009\",\"pontos\":10.0,\"posicao\":7.0},{\"cgccpf\":\"80000000010\",\"pontos\":10.0,\"posicao\":8.0},{\"cgccpf\":\"80000000015\",\"pontos\":10.0,\"posicao\":9.0},{\"cgccpf\":\"80000000004\",\"pontos\":9.0,\"posicao\":10.0},{\"cgccpf\":\"80000000016\",\"pontos\":9.0,\"posicao\":11.0},{\"cgccpf\":\"07197793912\",\"pontos\":8.0,\"posicao\":12.0},{\"cgccpf\":\"80000000002\",\"pontos\":8.0,\"posicao\":13.0},{\"cgccpf\":\"80000000008\",\"pontos\":8.0,\"posicao\":14.0},{\"cgccpf\":\"80000000014\",\"pontos\":8.0,\"posicao\":15.0},{\"cgccpf\":\"46972978904\",\"pontos\":7.0,\"posicao\":16.0},{\"cgccpf\":\"80000000001\",\"pontos\":7.0,\"posicao\":17.0},{\"cgccpf\":\"80000000013\",\"pontos\":7.0,\"posicao\":18.0},{\"cgccpf\":\"80000000020\",\"pontos\":7.0,\"posicao\":19.0},{\"cgccpf\":\"80000000005\",\"pontos\":6.0,\"posicao\":20.0}]"}
    // obs: se o cpf enviado tiver alguma pontuacao, ele ira aparecer no rank juntamente com 1 acima e 1 abaixo dele, msm q nao esteja no top 20
    },
),
*/