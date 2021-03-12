# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     EventApp07.Repo.insert!(%EventApp07.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias EventApp07.Repo
alias EventApp07.Users.User
alias EventApp07.Events.Event

alice = Repo.insert!(%User{name: "alice", email: "alice@mail"})
bob = Repo.insert!(%User{name: "bob", email: "bob@mail"})

Repo.insert!(%Event{user_id: alice.id, title: "Alice's Event", date: "March 10 2021", desc: "Alice's first event."})
Repo.insert!(%Event{user_id: bob.id, title: "Bob's Event", date: "March 12 2021", desc: "Bob's first event."})
