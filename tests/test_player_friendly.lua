-- File: test_player_friendship.lua

local function mockPlayer(userId)
    return {
        UserId = userId,
        IsFriendsWith = function(self, otherUserId)
            -- Mock implementation: players are friends if their IDs are both even or both odd
            return self.UserId % 2 == otherUserId % 2
        end
    }
end

local function isPlayerFriended(player, otherPlayer)
    local success, result = pcall(function()
        return player:IsFriendsWith(otherPlayer.UserId)
    end)
    return success and result
end

-- Test cases
local tests = {
    function()
        local player1 = mockPlayer(2)
        local player2 = mockPlayer(4)
        assert(isPlayerFriended(player1, player2), "Test 1 failed: Even-numbered players should be friends")
    end,
    function()
        local player1 = mockPlayer(1)
        local player2 = mockPlayer(3)
        assert(isPlayerFriended(player1, player2), "Test 2 failed: Odd-numbered players should be friends")
    end,
    function()
        local player1 = mockPlayer(1)
        local player2 = mockPlayer(2)
        assert(not isPlayerFriended(player1, player2), "Test 3 failed: Odd and even numbered players should not be friends")
    end
}

-- Run tests
for i, test in ipairs(tests) do
    local success, error = pcall(test)
    if success then
        print("Test " .. i .. " passed")
    else
        print("Test " .. i .. " failed: " .. error)
    end
end