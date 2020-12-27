
class constants {
    static String token = "";
    static bool sent  = false;
    static bool isSick = false;

    static setSickness(bool sick) async
    {
      isSick = sick;
    }
    static void SetSent(bool issent)
    {
        sent = issent;
    }
    static void SetToken(String newtoken)
    {
      token = newtoken;
    }

}
