# Mapping ligne (nom lisible) -> code STIF utilisé par l'API PRIM (general-message).
# Source: référentiel IDFM. Pour ajouter une ligne (ex. un tram), chercher son code
# STIF via le catalogue PRIM (recherche d'une ligne) et l'ajouter ici.
LINE_STIF_CODES = {
    "1": "C01371",
    "2": "C01372",
    "3": "C01373",
    "3bis": "C01386",
    "4": "C01374",
    "5": "C01375",
    "6": "C01376",
    "7": "C01377",
    "7bis": "C01387",
    "8": "C01378",
    "9": "C01379",
    "10": "C01380",
    "11": "C01381",
    "12": "C01382",
    "13": "C01383",
    "14": "C01384",
    "A": "C01742",
    "B": "C01743",
    "C": "C01727",
    "D": "C01728",
    "E": "C01729",
    "H": "C01737",
    "J": "C01739",
    "K": "C01738",
    "L": "C01740",
    "N": "C01736",
    "P": "C01730",
    "R": "C01731",
    "U": "C01741",
    "V": "C02711",
}

DEFAULT_LINES = ["A", "B", "C", "D", "E", "1", "4", "14"]


def line_ref(line: str) -> str:
    code = LINE_STIF_CODES.get(line)
    if code is None:
        raise ValueError(f"Ligne inconnue: {line!r}. Lignes disponibles: {sorted(LINE_STIF_CODES)}")
    return f"STIF:Line::{code}:"
