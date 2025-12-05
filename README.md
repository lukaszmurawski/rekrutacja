# PROJEKT ZARZĄDZANIA DANYMI: SYMFONY + PHOENIX

## Jak to działa? 

Cała aplikacja działa w trzech kontenerach Docker, które razem tworzą środowisko:

1. **Symfony (Frontend/Gateway):** To, co widzi użytkownik. Obsługuje interfejs graficzny, formularze i działa jako Gateway do warstwy Elixir.

2. **Phoenix (Backend/Logika):** Core systemu. Zajmuje się logiką biznesową, walidacją, i jako jedyny ma bezpośredni dostęp do bazy danych.

3. **PostgreSQL (Baza Danych):** Trwały magazyn danych, używany wyłącznie przez aplikację Phoenix.

**Schemat Komunikacji:**
Żądania idą z **Symfony** → do **Phoenix** (API) → do **PostgreSQL**.


## Start Projektu (Lokalne Środowisko)

Do uruchomienia potrzebujesz tylko Dockera.

### 1. Uruchomienie Serwisów

Zbuduj obrazy i uruchom kontenery oraz odpal migracje komendami:
```bash
docker-compose up -d --build
docker-compose exec phoenix mix ecto.setup
```

## Dostęp do Aplikacji

Aplikacja jest już dostępna w przeglądarce.

| Usługa | Adres Lokalny | Cel | 
 | ----- | ----- | ----- | 
| **Panel Zarządzania** | **http://localhost:8000/** | Dodawanie, edycja i przeglądanie osób. | 

### Dostęp do Bazy Danych (Dla Deweloperów)

Jeśli potrzebujesz bezpośredniego dostępu do bazy danych możesz użyć tych parametrów:

* **Host:** `localhost`
* **Port:** `5432`

## Ważne Uwagi Użytkowe

* Formularz dodawania/edycji jest celowo umieszczony na dole strony, pod listą osób.

* Pusta Lista: Jeśli baza danych jest pusta (brak żadnych rekordów), nie zobaczysz listy osób. Będzie widoczny tylko formularz, którym możesz dodać pierwszą osobę.

* Przycisk "import" wegeneruje 100 osób z losowymi personaliami

* Filtrowanie przyjmuje tylko litery, odświeża listę 3 sekundy po wpisaniu ostatniej litery w pole filtra