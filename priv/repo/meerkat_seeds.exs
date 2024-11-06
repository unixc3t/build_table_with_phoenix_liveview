# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Mhm.Repo.insert!(%Mhm.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Mhm.Repo
alias Mhm.Meerkats.Meerkat


for i <- 1..10 do
    Repo.insert! %Meerkat{
        name: "demo#{i}"
    }
end


for i <- 1..10 do
    Repo.insert! %Meerkat{
        name: "bike#{i}"
    }
end
