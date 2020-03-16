#include <amxmodx> 
#include <fun> 
#include <cstrike> 
#include <engine> 
#include <hamsandwich>

#include <jopomen>  

#define    FL_WATERJUMP    (1<<11)
#define    FL_ONGROUND    (1<<9)
#define PLUGIN "XMenu"
#define VERSION "1.0"
#define AUTHOR "Ayrat"
#define XSPEED 350.0

new g_bunny[33]
new bh_enabled
new bh_autojump
new bh_showusage
new bool:invis[33]
new bool:godmode[33]
new bool:noclip[33]
new bool:footsteps[33]
new bool:speed[33]
new bool:gravity[33]
new bool:svechenie[33]
new bool:bhop[33]
new spawncounter; 
new num = 15
//new SayText;

public plugin_init() 
{ 
    register_clcmd( "xmenu", "XMenu" ); 
    register_clcmd( "say /xmenu", "XMenu" ); 
    register_clcmd( "say_team /xmenu", "XMenu" );
    register_clcmd("bhop", "cmdBunny")

    SayText = get_user_msgid("SayText")
	RegisterHam(Ham_Item_PreFrame, "player", "PlayerResetMaxSpeed", 0); 
	bh_enabled = register_cvar("bh_enabled", "1")
    bh_autojump = register_cvar("bh_autojump", "1")
} 
public client_connect(id)
{
        client_cmd(id, "bind ^"v^" ^"say /xmenu^"")
		g_bunny[id] = 0
}
public PlayerResetMaxSpeed(pPlayer)

{
        if (!is_user_connected(pPlayer))

                return HAM_IGNORED;

        if (get_user_maxspeed(pPlayer) != XSPEED)

                return HAM_IGNORED;

        return HAM_SUPERCEDE;
}
public cmdBunny(id)
{
  g_bunny[id] = 1 - g_bunny[id]
  return PLUGIN_CONTINUE
}
public client_PreThink(id)
{
        if(get_user_flags(id) & ADMIN_LEVEL_H) 
        {  
               if ( !get_pcvar_num(bh_enabled) || !g_bunny[id] )
               return

               entity_set_float(id, EV_FL_fuser2, 0.0)       

               if ( !get_pcvar_num(bh_autojump) )
               return

               if ( entity_get_int(id, EV_INT_button) & 2 )
               {
               new flags = entity_get_int(id, EV_INT_flags)

               if (flags & FL_WATERJUMP)
               return
               if ( entity_get_int(id, EV_INT_waterlevel) >= 2 )
               return
               if ( !(flags & FL_ONGROUND) )
               return

               new Float:velocity[3]
               entity_get_vector(id, EV_VEC_velocity, velocity)
               velocity[2] += 250.0
               entity_set_vector(id, EV_VEC_velocity, velocity)

               entity_set_int(id, EV_INT_gaitsequence, 6)  
        }
    }
}
public Revive_Counter(id)
{
	    num--
	     
	    if(num > 0 )
		{
	        ColorChat(id,print_chat,"^4[UKM] ^4У ^3вас ^4осталось %d ^4антизастревалок.", num)
	    }
		else
		{
	        ColorChat(id,print_chat,"^4[UKM] ^4У ^3вас ^4кончались 4антизастревалки.", num)
	    }
}
public XMenu(id) 
{ 
        if(get_user_flags(id) & ADMIN_LEVEL_H) 
        {   
            new msg[222], name[32]
            get_user_name(id, name, 31)
            formatex(msg, charsmax(msg), "\wМеню для \rадминистрации:^n\wДоброго времени суток, %s!^n\rСтраница:", name)
            new xmenu = menu_create(msg, "menu_handler") 
            menu_additem( xmenu, "\yОбновить меню[Если зависло]", "1", 0 ); 
			menu_additem( xmenu, "\yЕсли застрял на карте", "2", 0 ); 
			menu_addblank( xmenu, 0)
            menu_additem( xmenu, "\wГранаты: \rВсе", "3", 0 ); 

			if(gravity[id]==true)
            {
            menu_additem( xmenu,"\wГравитация: \rВыкл","4")
            }
            else
            {
            menu_additem( xmenu,"\wГравитация: \yВкл","4")
            } 			
			
			if(speed[id]==true)
            {
            menu_additem( xmenu,"\wСкорость: \rВыкл","5")
            }
            else
            {
            menu_additem( xmenu,"\wСкорость: \yВкл","5")
            } 
			
			if(invis[id]==true)
            {
            menu_additem( xmenu,"\wНевидимость: \rВыкл","6")
            }
            else
            {
            menu_additem( xmenu,"\wНевидимость: \yВкл","6")
            } 
			
			if(noclip[id]==true)
            {
            menu_additem( xmenu,"\wСквозь стены: \rВыкл","7")
            }
            else
            {
            menu_additem( xmenu,"\wСквозь стены: \yВкл","7")
            } 
			
            if(godmode[id]==true)
            {
            menu_additem( xmenu,"\wБессмертие: \rВыкл","8")
            }
            else
            {
            menu_additem( xmenu,"\wБессмертие: \yВкл","8")
            } 
			
			if(footsteps[id]==true)
            {
            menu_additem( xmenu,"\wТихий шаг: \rВыкл","9")
            }
            else
            {
            menu_additem( xmenu,"\wТихий шаг: \yВкл","9")
            } 
			
			if(svechenie[id]==true)
            {
            menu_additem( xmenu,"\wСвечение: \rВыкл","10")
            }
            else
            {
            menu_additem( xmenu,"\wСвечение: \yВкл","10")
            } 
			
			if(bhop[id]==true)
            {
            menu_additem( xmenu,"\wАвтораспрыжка: \rВыкл","11")
            }
            else
            {
            menu_additem( xmenu,"\wАвтораспрыжка: \yВкл","11")
            } 
			
            menu_additem( xmenu, "\wСнаряжение: [\r255хп/армор\w]", "12", 0); 
			menu_additem( xmenu, "\wВзять \rD\wesert \rE\wagle", "13", 0);
			menu_additem( xmenu, "\wВзять \rAK\w-47", "14", 0);
			menu_additem( xmenu, "\wВзять \rM4\wa1", "15", 0);
		    menu_additem( xmenu, "\wВзять \rAWP", "16", 0);
			
			menu_setprop( xmenu, MPROP_NEXTNAME, "\rДальше")
			menu_setprop( xmenu, MPROP_BACKNAME, "Назад")
            menu_setprop( xmenu, MPROP_EXITNAME, "\rВыход" ); 
            menu_display( id, xmenu, 0 ); 
        } 
        else 
        { 
            ColorChat(id,print_chat, "^4[UKM] Вы не имеете соответствующие ^3права ^4для открытия меню.") 
        }  
} 
	
public Spawn_player(id)
{
	if(is_user_alive(id) && is_user_connected(id))
	{
            set_user_rendering(id, kRenderFxGlowShell, 0, 0, 0, kRenderNormal,0)
            set_view( id, 0 )
            cs_set_user_armor(id, 0, CS_ARMOR_NONE)
            set_user_maxspeed(id, 250.0)
            set_user_gravity( id, 1.0 )
            set_user_health( id, 100 )
            set_user_noclip(id, 0)
            set_user_godmode(id, 0)
	}
}

public menu_handler( id, menu, item ) 
{ 
    if( item == MENU_EXIT ) 
    { 
        menu_destroy( menu ); 
        return PLUGIN_HANDLED; 
    } 
    new data[6], iName[64]; 
    new access, callback; 
     
    menu_item_getinfo( menu, item, access, data,5, iName, 63, callback ); 
    new key = str_to_num( data ); 
    switch( key ) 
    { 
		case 1: 
        { 
            if( is_user_alive( id ) ) 
            { 
            cs_set_user_money(id, 16000)
			ColorChat(id,print_chat,"^4[UKM] ^3Вы ^4обновили админ меню.")
            } 
		XMenu(id)
        } 
		case 2: 
        { 
            if(spawncounter != 15)
            {
                        ExecuteHamB(Ham_CS_RoundRespawn,id);
						Revive_Counter(id)
            }
			else
			{
			            return PLUGIN_HANDLED
			}
            spawncounter++;
            return PLUGIN_CONTINUE;
			XMenu(id)
        } 
        case 3: 
        { 
            if( is_user_alive( id ) ) 
            { 
                give_item( id, "weapon_hegrenade" )
                give_item( id, "weapon_flashbang" )
                give_item( id, "weapon_flashbang" )
                give_item( id, "weapon_smokegrenade" )
				ColorChat(id,print_chat,"^4[UKM] ^3Вы ^4взяли все гранаты.")
            }
		XMenu(id)	
        } 
		case 4:
        {    
		    if( is_user_alive( id ) )  
			{
                switch(gravity[id])
                {
                    case true:
                    {
                    set_user_gravity( id, 1.0 )
                    gravity[id]=false
					ColorChat(id,print_chat,"^4[UKM] ^3Вы ^4выключили гравитацию.")
                    }
                    case false:
                    {
                    set_user_gravity( id, 0.3 )
                    gravity[id]=true
					ColorChat(id,print_chat,"^4[UKM] ^3Вы ^4включили гравитацию.")
                    }
                }
			}	
			XMenu(id)
        }   
		case 5:
        {    
		    if( is_user_alive( id ) )  
			{
                switch(speed[id])
                {
                    case true:
                    {
                    set_user_maxspeed(id, 250.0);
                    speed[id]=false
					ColorChat(id,print_chat,"^4[UKM] ^3Вы ^4выключили скорость.")
                    }
                    case false:
                    {
                    set_user_maxspeed(id, XSPEED);
                    speed[id]=true
					ColorChat(id,print_chat,"^4[UKM] ^3Вы ^4включили скорость.")
                    }
                }
			}
        XMenu(id)			
        }   
        case 6:
        {    
		    if( is_user_alive( id ) )  
			{
                switch(invis[id])
                {
                    case true:
                    {
                    set_user_rendering(id, kRenderFxGlowShell, 0, 0, 0, kRenderNormal,0)
                    invis[id]=false
					ColorChat(id,print_chat,"^4[UKM] ^3Вы ^4выключили невидимость.")
                    }
                    case false:
                    {
                    set_user_rendering(id,kRenderFxNone, 0,0,0, kRenderTransAdd,3) 
                    invis[id]=true
					ColorChat(id,print_chat,"^4[UKM] ^3Вы ^4включили невидимость.")					
                    }
                }	
			}
        XMenu(id)			
        }   
        case 7:
        {
            switch(noclip[id])
            {
                    case true:
                    {
                    set_user_noclip(id,0)
                    noclip[id]=false
					ColorChat(id,print_chat,"^4[UKM] ^3Вы ^4выключили сквозь стены.")
                    }
                    case false:
                    {
                    set_user_noclip(id,1)
                    noclip[id]=true
					ColorChat(id,print_chat,"^4[UKM] ^3Вы ^4включили сквозь стены.")
                    }
            }
		XMenu(id)	
        }   
        case 8:
        {
            switch(godmode[id])
            {

                    case true:
                    {
                    set_user_godmode(id,0)
                    godmode[id]=false
					ColorChat(id,print_chat,"^4[UKM] ^3Вы ^4выключили режим бога.")
                    }
                    case false:
                    {
                    set_user_godmode(id,1)
                    godmode[id]=true
					ColorChat(id,print_chat,"^4[UKM] ^3Вы ^4включили режим бога.")
                    }

            }
		XMenu(id)	
        } 
		case 9:
        {
            switch(footsteps[id])
            {

                    case true:
                    {
                    set_user_footsteps(id, 0);
                    footsteps[id]=false
					ColorChat(id,print_chat,"^4[UKM] ^3Вы ^4выключили тихий шаг.")
                    }
                    case false:
                    {
                    set_user_footsteps(id, 1);
                    footsteps[id]=true
					ColorChat(id,print_chat,"^4[UKM] ^3Вы ^4включили тихий шаг.")
                    }

            }
        }   
		case 10:
        {    
		    if( is_user_alive( id ) )  
			{
                switch(svechenie[id])
                {
                    case true:
                    {
                    set_user_rendering(id, kRenderFxGlowShell, 0, 0, 0, kRenderNormal, 0)
                    svechenie[id]=false
					ColorChat(id,print_chat,"^4[UKM] ^3Вы ^4выключили свечение.")
                    }
                    case false:
                    {
                    set_user_rendering(id, kRenderFxGlowShell, 0, 250, 0, kRenderNormal, 0)
                    svechenie[id]=true
					ColorChat(id,print_chat,"^4[UKM] ^3Вы ^4включили свечение.")
                    }
                }
			}	
        }   	
		case 11:
        {    
		    if( is_user_alive( id ) )  
			{
                switch(bhop[id])
                {
                    case true:
                    {
                    client_cmd(id, "bhop")
					ColorChat(id,print_chat,"^4[UKM] ^3Вы ^4выключили автораспрыжку.")
                    bhop[id]=false
                    }
                    case false:
                    {
                    client_cmd(id, "bhop")
					ColorChat(id,print_chat,"^4[UKM] ^3Вы ^4включили автораспрыжку.")
                    bhop[id]=true
                    }
                }
			}	
        }   		
        case 12: 
        { 
            if( is_user_alive( id ) ) 
            { 
            set_user_armor(id, 255)
            set_user_health(id, 255)
			ColorChat(id,print_chat,"^4[UKM] ^3Вы ^4взяли жизни и броню.")
            } 
        } 	
		case 13:
		{
		    if( is_user_alive( id ) ) 
            { 
            give_item(id,"weapon_deagle")
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			give_item(id,"ammo_50ae")
			ColorChat(id,print_chat,"^4[UKM] ^3Вы ^4взяли дигл.")
            } 
		}
		case 14:
		{
		    if( is_user_alive( id ) ) 
            { 
			give_item(id,"weapon_ak47")
			give_item(id,"ammo_762nato")
			give_item(id,"ammo_762nato")
			give_item(id,"ammo_762nato")
			give_item(id,"ammo_762nato")
			ColorChat(id,print_chat,"^4[UKM] ^3Вы ^4взяли ak-47.")
            } 
		}
		case 15:
		{
		    if( is_user_alive( id ) ) 
            { 
			give_item(id,"weapon_m4a1")
			give_item(id,"ammo_556nato")
			give_item(id,"ammo_556nato")
			give_item(id,"ammo_556nato")
			give_item(id,"ammo_556nato")
			ColorChat(id,print_chat,"^4[UKM] ^3Вы ^4взяли m4a1.")
            } 
		}
		case 16:
		{
		    if( is_user_alive( id ) ) 
            { 
			give_item(id,"weapon_awp")
			give_item(id,"ammo_338magnum")
			give_item(id,"ammo_338magnum")
			give_item(id,"ammo_338magnum")
			give_item(id,"ammo_338magnum")
			ColorChat(id,print_chat,"^4[UKM] ^3Вы ^4взяли снайперскую винтовку (AWP).")
            } 
		}
    }
} 
stock print_col_chat(const id, const input[], any:...) 
{ 
    new count = 1, players[32]; 
    static msg[191]; 
    vformat(msg, 190, input, 3); 
    replace_all(msg, 190, "!g", "^4"); // Green Color 
    replace_all(msg, 190, "!y", "^1"); // Default Color
    replace_all(msg, 190, "!t", "^3"); // Team Color 
    if (id) players[0] = id; else get_players(players, count, "ch"); 
    { 
        for ( new i = 0; i < count; i++ ) 
        { 
            if ( is_user_connected(players[i]) ) 
            { 
                message_begin(MSG_ONE_UNRELIABLE, SayText, _, players[i]); 
                write_byte(players[i]); 
                write_string(msg); 
                message_end(); 
            } 
        } 
    } 
} 
