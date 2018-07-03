local MOD = RegisterMod("HolyMantleStatus", 1);

local CONFIG = {
    safe_string = "safe",
    safe_string_alpha = 0.25,
    danger_string = "DANGER",
    dynamic_text = true,
    static_offset_x = 0,
    static_offset_y = -35,
    dynamic_offset_x = 0,
    dynamic_offset_y = 5,
}

function onRender(t)
    local player = Isaac.GetPlayer(0)

    local text_function

    if CONFIG.dynamic_text then
        text_function = dynamicText
    else
        text_function = staticText
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_HOLY_MANTLE) then
        if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE) then
            renderText(CONFIG.safe_string, text_function, 1, 1, 1, CONFIG.safe_string_alpha)
        else
            renderText(CONFIG.danger_string, text_function, 1, 0, 0, 256)
        end
    end
end

function dynamicText(str)
    local player_position = Isaac.WorldToRenderPosition(Isaac.GetPlayer(0).Position, 2)

    local scroll_offset = Game():GetRoom():GetRenderScrollOffset()

    local text_width_half = Isaac.GetTextWidth(str) / 2.0

    local x = player_position.X + CONFIG.dynamic_offset_x + scroll_offset.X - text_width_half
    local y = player_position.Y + CONFIG.dynamic_offset_y + scroll_offset.Y

    return x, y
end

function staticText(str)
    local dimension = Game():GetRoom():GetRenderSurfaceTopLeft() * 2 + Vector(442, 286)

    local text_width_half = (Isaac.GetTextWidth(str) / 2.0)

    local x = (dimension.X / 2.0) + CONFIG.static_offset_x - text_width_half
    local y = dimension.Y + CONFIG.static_offset_y

    return x, y
end

function renderText(str, positionProducer, r, g, b, a)
    local x, y = positionProducer(str)

    Isaac.RenderText(str, x, y, r, g, b, a)
end

MOD:AddCallback(ModCallbacks.MC_POST_RENDER, onRender)