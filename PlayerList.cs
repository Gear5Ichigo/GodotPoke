using Godot;
using Godot.Collections;
using System;

public partial class PlayerList : VBoxContainer
{
	Node GameManager;
	Dictionary players;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GameManager = GetTree().Root.GetNode("GameManager");
		players = GameManager.Get("Players").As<Dictionary>();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{}
	
	private void _on_control_padd()
	{
		foreach(Node n in GetChildren()) {
			n.QueueFree();
		}
		foreach(var s in players) {
			GD.Print(s.Get("Name"));
		}
	}		
}
