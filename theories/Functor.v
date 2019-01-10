Set Implicit Arguments.
Unset Strict Implicit.
Unset Printing Implicit Defensive.

Require Import Coq.Logic.FunctionalExtensionality.
Require Import Coq.Logic.ProofIrrelevance.
Require Import Program.

(* Functor *)
Class IsFunctor (F : Set -> Set) :=
  {
    fmap : forall {A B : Set}, (A -> B) -> F A -> F B;
    fmap_id : forall {A : Set}, @fmap A A (fun x => x) = (fun fx => fx);
    fmap_compose : forall {A B C : Set} (f : A -> B) (g : B -> C),
        fmap (fun a => g (f a)) = (fun fa => fmap g (fmap f fa));
  }.

Theorem fmap_id' {F : Set -> Set} {functor : IsFunctor F} {A : Set} :
  forall (fx : F A), fmap (fun x => x) fx = fx.
Proof.
  intros fx.
  rewrite fmap_id.
  reflexivity.
Qed.

Theorem fmap_compose' {F : Set -> Set} {functor : IsFunctor F} {A B C : Set} :
  forall (f : A -> B) (g : B -> C) (fx : F A),
    fmap (fun a => g (f a)) fx = fmap g (fmap f fx).
Proof.
  intros f g fx.
  rewrite fmap_compose.
  reflexivity.
Qed.

Definition Identity : Set -> Set := fun A => A.

Instance IdentityFunctor : IsFunctor Identity :=
  { fmap A B := fun f a => f a }.
Proof.
  unfold Identity; reflexivity.
  unfold Identity; reflexivity.
Qed.

Definition Snd : Set -> Set -> Set := prod.

Instance SndFunctor {K : Set} : IsFunctor (Snd K) :=
  { fmap A B := fun f ka => match ka with pair k a => pair k (f a) end }.
Proof.
  - intros A.
    extensionality ka; destruct ka.
    reflexivity.
  - intros A B C f g.
    extensionality ka; destruct ka.
    reflexivity.
Qed.

Instance ComposeFunctor {F G : Set -> Set} (functorF : IsFunctor F) (functorG : IsFunctor G) : IsFunctor (fun X => F (G X)) :=
  { fmap A B := fun f fga => fmap (@fmap G functorG A B f) fga }.
Proof.
  - intros A.
    rewrite fmap_id.
    rewrite fmap_id.
    reflexivity.
  - intros A B C f g.
    rewrite (fmap_compose f g).
    rewrite (fmap_compose (fmap f) (fmap g)).
    reflexivity.
Qed.
