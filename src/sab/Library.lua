local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {}

function Library:CreateWindow(title)
	local player = game.Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CustomGui"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = playerGui
	
	local toggleButton = Instance.new("ImageButton")
	toggleButton.Name = "ToggleButton"
	toggleButton.Size = UDim2.new(0, 50, 0, 50)
	toggleButton.Position = UDim2.new(1, -70, 0, 20)
	toggleButton.BackgroundColor3 = Color3.fromRGB(80, 40, 130)
	toggleButton.BorderSizePixel = 0
	toggleButton.Image = "rbxassetid://105338847670181"
	toggleButton.Parent = screenGui
	
	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(0, 10)
	toggleCorner.Parent = toggleButton
	
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 700, 0, 500)
	mainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
	mainFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
	mainFrame.BorderSizePixel = 0
	mainFrame.Visible = false
	mainFrame.Parent = screenGui
	
	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 15)
	mainCorner.Parent = mainFrame
	
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 50)
	header.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
	header.BorderSizePixel = 0
	header.Parent = mainFrame
	
	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 15)
	headerCorner.Parent = header
	
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -100, 1, 0)
	titleLabel.Position = UDim2.new(0, 20, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title or "ArtHub"
	titleLabel.TextColor3 = Color3.fromRGB(150, 100, 255)
	titleLabel.TextSize = 20
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = header
	
	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0, 35, 0, 35)
	closeButton.Position = UDim2.new(1, -45, 0.5, -17.5)
	closeButton.BackgroundColor3 = Color3.fromRGB(180, 50, 70)
	closeButton.BorderSizePixel = 0
	closeButton.Text = "X"
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.TextSize = 18
	closeButton.Font = Enum.Font.GothamBold
	closeButton.Parent = header
	
	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 8)
	closeCorner.Parent = closeButton
	
	local container = Instance.new("Frame")
	container.Name = "Container"
	container.Size = UDim2.new(1, 0, 1, -50)
	container.Position = UDim2.new(0, 0, 0, 50)
	container.BackgroundTransparency = 1
	container.Parent = mainFrame
	
	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.Size = UDim2.new(0, 180, 1, 0)
	sidebar.BackgroundColor3 = Color3.fromRGB(18, 12, 30)
	sidebar.BorderSizePixel = 0
	sidebar.Parent = container
	
	local sidebarList = Instance.new("UIListLayout")
	sidebarList.Padding = UDim.new(0, 5)
	sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
	sidebarList.Parent = sidebar
	
	local sidebarPadding = Instance.new("UIPadding")
	sidebarPadding.PaddingTop = UDim.new(0, 10)
	sidebarPadding.PaddingLeft = UDim.new(0, 10)
	sidebarPadding.PaddingRight = UDim.new(0, 10)
	sidebarPadding.Parent = sidebar
	
	local contentArea = Instance.new("Frame")
	contentArea.Name = "ContentArea"
	contentArea.Size = UDim2.new(1, -180, 1, 0)
	contentArea.Position = UDim2.new(0, 180, 0, 0)
	contentArea.BackgroundTransparency = 1
	contentArea.Parent = container
	
	local notificationContainer = Instance.new("Frame")
	notificationContainer.Name = "Notifications"
	notificationContainer.Size = UDim2.new(0, 300, 1, 0)
	notificationContainer.Position = UDim2.new(1, -320, 0, 80)
	notificationContainer.BackgroundTransparency = 1
	notificationContainer.Parent = screenGui
	
	local notificationList = Instance.new("UIListLayout")
	notificationList.Padding = UDim.new(0, 10)
	notificationList.SortOrder = Enum.SortOrder.LayoutOrder
	notificationList.VerticalAlignment = Enum.VerticalAlignment.Bottom
	notificationList.Parent = notificationContainer
	
	local isOpen = false
	toggleButton.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		mainFrame.Visible = isOpen
	end)
	
	closeButton.MouseButton1Click:Connect(function()
		isOpen = false
		mainFrame.Visible = false
	end)
	
	local Window = {
		ScreenGui = screenGui,
		MainFrame = mainFrame,
		Sidebar = sidebar,
		ContentArea = contentArea,
		NotificationContainer = notificationContainer,
		Tabs = {}
	}
	
	function Window:Notify(title, text, duration)
		duration = duration or 3
		
		local notification = Instance.new("Frame")
		notification.Size = UDim2.new(1, 0, 0, 80)
		notification.BackgroundColor3 = Color3.fromRGB(25, 18, 40)
		notification.BorderSizePixel = 0
		notification.Parent = notificationContainer
		
		local notifCorner = Instance.new("UICorner")
		notifCorner.CornerRadius = UDim.new(0, 10)
		notifCorner.Parent = notification
		
		local notifBorder = Instance.new("UIStroke")
		notifBorder.Color = Color3.fromRGB(100, 60, 160)
		notifBorder.Thickness = 2
		notifBorder.Parent = notification
		
		local notifTitle = Instance.new("TextLabel")
		notifTitle.Size = UDim2.new(1, -20, 0, 25)
		notifTitle.Position = UDim2.new(0, 10, 0, 5)
		notifTitle.BackgroundTransparency = 1
		notifTitle.Text = title
		notifTitle.TextColor3 = Color3.fromRGB(150, 100, 255)
		notifTitle.TextSize = 16
		notifTitle.Font = Enum.Font.GothamBold
		notifTitle.TextXAlignment = Enum.TextXAlignment.Left
		notifTitle.Parent = notification
		
		local notifText = Instance.new("TextLabel")
		notifText.Size = UDim2.new(1, -20, 1, -35)
		notifText.Position = UDim2.new(0, 10, 0, 30)
		notifText.BackgroundTransparency = 1
		notifText.Text = text
		notifText.TextColor3 = Color3.fromRGB(200, 200, 200)
		notifText.TextSize = 14
		notifText.Font = Enum.Font.Gotham
		notifText.TextXAlignment = Enum.TextXAlignment.Left
		notifText.TextYAlignment = Enum.TextYAlignment.Top
		notifText.TextWrapped = true
		notifText.Parent = notification
		
		notification.Position = UDim2.new(1, 20, 0, 0)
		
		local tweenIn = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Position = UDim2.new(0, 0, 0, 0)
		})
		tweenIn:Play()
		
		task.wait(duration)
		
		local tweenOut = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Position = UDim2.new(1, 20, 0, 0)
		})
		tweenOut:Play()
		tweenOut.Completed:Connect(function()
			notification:Destroy()
		end)
	end
	
	function Window:CreateTab(name)
		local tabButton = Instance.new("TextButton")
		tabButton.Name = name
		tabButton.Size = UDim2.new(1, 0, 0, 40)
		tabButton.BackgroundColor3 = Color3.fromRGB(25, 18, 40)
		tabButton.BorderSizePixel = 0
		tabButton.Text = name
		tabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
		tabButton.TextSize = 16
		tabButton.Font = Enum.Font.Gotham
		tabButton.Parent = sidebar
		
		local tabCorner = Instance.new("UICorner")
		tabCorner.CornerRadius = UDim.new(0, 8)
		tabCorner.Parent = tabButton
		
		local tabContent = Instance.new("ScrollingFrame")
		tabContent.Name = name .. "Content"
		tabContent.Size = UDim2.new(1, -20, 1, -20)
		tabContent.Position = UDim2.new(0, 10, 0, 10)
		tabContent.BackgroundTransparency = 1
		tabContent.BorderSizePixel = 0
		tabContent.ScrollBarThickness = 6
		tabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 60, 160)
		tabContent.Visible = false
		tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
		tabContent.Parent = contentArea
		
		local contentList = Instance.new("UIListLayout")
		contentList.Padding = UDim.new(0, 10)
		contentList.SortOrder = Enum.SortOrder.LayoutOrder
		contentList.Parent = tabContent
		
		contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			tabContent.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 10)
		end)
		
		tabButton.MouseButton1Click:Connect(function()
			for _, tab in pairs(Window.Tabs) do
				tab.Button.BackgroundColor3 = Color3.fromRGB(25, 18, 40)
				tab.Button.TextColor3 = Color3.fromRGB(150, 150, 150)
				tab.Content.Visible = false
			end
			tabButton.BackgroundColor3 = Color3.fromRGB(60, 35, 100)
			tabButton.TextColor3 = Color3.fromRGB(200, 150, 255)
			tabContent.Visible = true
		end)
		
		if #Window.Tabs == 0 then
			tabButton.BackgroundColor3 = Color3.fromRGB(60, 35, 100)
			tabButton.TextColor3 = Color3.fromRGB(200, 150, 255)
			tabContent.Visible = true
		end
		
		local Tab = {
			Button = tabButton,
			Content = tabContent,
			Elements = {}
		}
		
		table.insert(Window.Tabs, Tab)
		
		function Tab:CreateSection(name)
			local sectionFrame = Instance.new("Frame")
			sectionFrame.Name = name
			sectionFrame.Size = UDim2.new(1, 0, 0, 40)
			sectionFrame.BackgroundColor3 = Color3.fromRGB(25, 18, 40)
			sectionFrame.BorderSizePixel = 0
			sectionFrame.Parent = tabContent
			
			local sectionCorner = Instance.new("UICorner")
			sectionCorner.CornerRadius = UDim.new(0, 10)
			sectionCorner.Parent = sectionFrame
			
			local sectionBorder = Instance.new("UIStroke")
			sectionBorder.Color = Color3.fromRGB(100, 60, 160)
			sectionBorder.Thickness = 2
			sectionBorder.Parent = sectionFrame
			
			local sectionLabel = Instance.new("TextLabel")
			sectionLabel.Size = UDim2.new(1, -60, 1, 0)
			sectionLabel.Position = UDim2.new(0, 15, 0, 0)
			sectionLabel.BackgroundTransparency = 1
			sectionLabel.Text = name
			sectionLabel.TextColor3 = Color3.fromRGB(150, 100, 255)
			sectionLabel.TextSize = 16
			sectionLabel.Font = Enum.Font.GothamBold
			sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
			sectionLabel.Parent = sectionFrame
			
			local arrow = Instance.new("TextLabel")
			arrow.Size = UDim2.new(0, 30, 1, 0)
			arrow.Position = UDim2.new(1, -40, 0, 0)
			arrow.BackgroundTransparency = 1
			arrow.Text = "▼"
			arrow.TextColor3 = Color3.fromRGB(150, 100, 255)
			arrow.TextSize = 14
			arrow.Font = Enum.Font.GothamBold
			arrow.Parent = sectionFrame
			
			local sectionContent = Instance.new("Frame")
			sectionContent.Name = "SectionContent"
			sectionContent.Size = UDim2.new(1, 0, 0, 0)
			sectionContent.BackgroundTransparency = 1
			sectionContent.Parent = tabContent
			sectionContent.Visible = true
			
			local sectionContentList = Instance.new("UIListLayout")
			sectionContentList.Padding = UDim.new(0, 10)
			sectionContentList.SortOrder = Enum.SortOrder.LayoutOrder
			sectionContentList.Parent = sectionContent
			
			sectionContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				sectionContent.Size = UDim2.new(1, 0, 0, sectionContentList.AbsoluteContentSize.Y)
			end)
			
			local isExpanded = true
			sectionFrame.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					isExpanded = not isExpanded
					sectionContent.Visible = isExpanded
					arrow.Text = isExpanded and "▼" or "▶"
				end
			end)
			
			local Section = {
				Frame = sectionFrame,
				Content = sectionContent
			}
			
			function Section:CreateToggle(name, callback)
				local toggleFrame = Instance.new("Frame")
				toggleFrame.Size = UDim2.new(1, 0, 0, 40)
				toggleFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
				toggleFrame.BorderSizePixel = 0
				toggleFrame.Parent = sectionContent
				
				local toggleCorner = Instance.new("UICorner")
				toggleCorner.CornerRadius = UDim.new(0, 8)
				toggleCorner.Parent = toggleFrame
				
				local toggleLabel = Instance.new("TextLabel")
				toggleLabel.Size = UDim2.new(1, -80, 1, 0)
				toggleLabel.Position = UDim2.new(0, 15, 0, 0)
				toggleLabel.BackgroundTransparency = 1
				toggleLabel.Text = name
				toggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
				toggleLabel.TextSize = 15
				toggleLabel.Font = Enum.Font.Gotham
				toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
				toggleLabel.Parent = toggleFrame
				
				local toggleButton = Instance.new("TextButton")
				toggleButton.Size = UDim2.new(0, 50, 0, 24)
				toggleButton.Position = UDim2.new(1, -60, 0.5, -12)
				toggleButton.BackgroundColor3 = Color3.fromRGB(50, 40, 60)
				toggleButton.BorderSizePixel = 0
				toggleButton.Text = ""
				toggleButton.Parent = toggleFrame
				
				local toggleButtonCorner = Instance.new("UICorner")
				toggleButtonCorner.CornerRadius = UDim.new(1, 0)
				toggleButtonCorner.Parent = toggleButton
				
				local toggleCircle = Instance.new("Frame")
				toggleCircle.Size = UDim2.new(0, 20, 0, 20)
				toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
				toggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
				toggleCircle.BorderSizePixel = 0
				toggleCircle.Parent = toggleButton
				
				local circleCorner = Instance.new("UICorner")
				circleCorner.CornerRadius = UDim.new(1, 0)
				circleCorner.Parent = toggleCircle
				
				local isToggled = false
				toggleButton.MouseButton1Click:Connect(function()
					isToggled = not isToggled
					local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					
					if isToggled then
						TweenService:Create(toggleCircle, tweenInfo, {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
						TweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(100, 60, 160)}):Play()
					else
						TweenService:Create(toggleCircle, tweenInfo, {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
						TweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(50, 40, 60)}):Play()
					end
					
					if callback then
						callback(isToggled)
					end
				end)
				
				return {
					SetValue = function(self, value)
						isToggled = value
						if isToggled then
							toggleCircle.Position = UDim2.new(1, -22, 0.5, -10)
							toggleButton.BackgroundColor3 = Color3.fromRGB(100, 60, 160)
						else
							toggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
							toggleButton.BackgroundColor3 = Color3.fromRGB(50, 40, 60)
						end
					end
				}
			end
			
			function Section:CreateButton(name, callback)
				local button = Instance.new("TextButton")
				button.Size = UDim2.new(1, 0, 0, 40)
				button.BackgroundColor3 = Color3.fromRGB(60, 35, 100)
				button.BorderSizePixel = 0
				button.Text = name
				button.TextColor3 = Color3.fromRGB(255, 255, 255)
				button.TextSize = 15
				button.Font = Enum.Font.GothamBold
				button.Parent = sectionContent
				
				local buttonCorner = Instance.new("UICorner")
				buttonCorner.CornerRadius = UDim.new(0, 8)
				buttonCorner.Parent = button
				
				button.MouseButton1Click:Connect(function()
					local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					TweenService:Create(button, tweenInfo, {BackgroundColor3 = Color3.fromRGB(80, 50, 130)}):Play()
					wait(0.1)
					TweenService:Create(button, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 35, 100)}):Play()
					
					if callback then
						callback()
					end
				end)
			end
			
			function Section:CreateSlider(name, min, max, default, callback)
				local sliderFrame = Instance.new("Frame")
				sliderFrame.Size = UDim2.new(1, 0, 0, 60)
				sliderFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
				sliderFrame.BorderSizePixel = 0
				sliderFrame.Parent = sectionContent
				
				local sliderCorner = Instance.new("UICorner")
				sliderCorner.CornerRadius = UDim.new(0, 8)
				sliderCorner.Parent = sliderFrame
				
				local sliderLabel = Instance.new("TextLabel")
				sliderLabel.Size = UDim2.new(1, -80, 0, 20)
				sliderLabel.Position = UDim2.new(0, 15, 0, 5)
				sliderLabel.BackgroundTransparency = 1
				sliderLabel.Text = name
				sliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
				sliderLabel.TextSize = 15
				sliderLabel.Font = Enum.Font.Gotham
				sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
				sliderLabel.Parent = sliderFrame
				
				local sliderValue = Instance.new("TextLabel")
				sliderValue.Size = UDim2.new(0, 60, 0, 20)
				sliderValue.Position = UDim2.new(1, -70, 0, 5)
				sliderValue.BackgroundTransparency = 1
				sliderValue.Text = tostring(default)
				sliderValue.TextColor3 = Color3.fromRGB(150, 100, 255)
				sliderValue.TextSize = 14
				sliderValue.Font = Enum.Font.GothamBold
				sliderValue.Parent = sliderFrame
				
				local sliderBar = Instance.new("Frame")
				sliderBar.Size = UDim2.new(1, -30, 0, 6)
				sliderBar.Position = UDim2.new(0, 15, 1, -20)
				sliderBar.BackgroundColor3 = Color3.fromRGB(40, 30, 50)
				sliderBar.BorderSizePixel = 0
				sliderBar.Parent = sliderFrame
				
				local sliderBarCorner = Instance.new("UICorner")
				sliderBarCorner.CornerRadius = UDim.new(1, 0)
				sliderBarCorner.Parent = sliderBar
				
				local sliderFill = Instance.new("Frame")
				sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
				sliderFill.BackgroundColor3 = Color3.fromRGB(100, 60, 160)
				sliderFill.BorderSizePixel = 0
				sliderFill.Parent = sliderBar
				
				local sliderFillCorner = Instance.new("UICorner")
				sliderFillCorner.CornerRadius = UDim.new(1, 0)
				sliderFillCorner.Parent = sliderFill
				
				local sliderButton = Instance.new("TextButton")
				sliderButton.Size = UDim2.new(0, 16, 0, 16)
				sliderButton.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
				sliderButton.BackgroundColor3 = Color3.fromRGB(200, 150, 255)
				sliderButton.BorderSizePixel = 0
				sliderButton.Text = ""
				sliderButton.Parent = sliderBar
				
				local sliderButtonCorner = Instance.new("UICorner")
				sliderButtonCorner.CornerRadius = UDim.new(1, 0)
				sliderButtonCorner.Parent = sliderButton
				
				local dragging = false
				local currentValue = default
				
				sliderButton.MouseButton1Down:Connect(function()
					dragging = true
				end)
				
				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
					end
				end)
				
				UserInputService.InputChanged:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						local mousePos = input.Position.X
						local barPos = sliderBar.AbsolutePosition.X
						local barSize = sliderBar.AbsoluteSize.X
						local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
						currentValue = math.floor(min + (max - min) * percent)
						
						sliderValue.Text = tostring(currentValue)
						sliderFill.Size = UDim2.new(percent, 0, 1, 0)
						sliderButton.Position = UDim2.new(percent, -8, 0.5, -8)
						
						if callback then
							callback(currentValue)
						end
					end
				end)
				
				return {
					SetValue = function(self, value)
						currentValue = math.clamp(value, min, max)
						local percent = (currentValue - min) / (max - min)
						sliderValue.Text = tostring(currentValue)
						sliderFill.Size = UDim2.new(percent, 0, 1, 0)
						sliderButton.Position = UDim2.new(percent, -8, 0.5, -8)
					end
				}
			end
			
			function Section:CreateDropdown(name, options, callback)
				local dropdownFrame = Instance.new("Frame")
				dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
				dropdownFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
				dropdownFrame.BorderSizePixel = 0
				dropdownFrame.Parent = sectionContent
				dropdownFrame.ClipsDescendants = true
				
				local dropdownCorner = Instance.new("UICorner")
				dropdownCorner.CornerRadius = UDim.new(0, 8)
				dropdownCorner.Parent = dropdownFrame
				
				local dropdownButton = Instance.new("TextButton")
				dropdownButton.Size = UDim2.new(1, 0, 0, 40)
				dropdownButton.BackgroundTransparency = 1
				dropdownButton.Text = ""
				dropdownButton.Parent = dropdownFrame
				
				local dropdownLabel = Instance.new("TextLabel")
				dropdownLabel.Size = UDim2.new(1, -80, 0, 40)
				dropdownLabel.Position = UDim2.new(0, 15, 0, 0)
				dropdownLabel.BackgroundTransparency = 1
				dropdownLabel.Text = name
				dropdownLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
				dropdownLabel.TextSize = 15
				dropdownLabel.Font = Enum.Font.Gotham
				dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
				dropdownLabel.Parent = dropdownButton
				
				local selectedValue = Instance.new("TextLabel")
				selectedValue.Size = UDim2.new(0, 100, 0, 40)
				selectedValue.Position = UDim2.new(1, -130, 0, 0)
				selectedValue.BackgroundTransparency = 1
				selectedValue.Text = options[1] or "None"
				selectedValue.TextColor3 = Color3.fromRGB(150, 100, 255)
				selectedValue.TextSize = 14
				selectedValue.Font = Enum.Font.GothamBold
				selectedValue.TextXAlignment = Enum.TextXAlignment.Right
				selectedValue.Parent = dropdownButton
				
				local dropdownArrow = Instance.new("TextLabel")
				dropdownArrow.Size = UDim2.new(0, 30, 0, 40)
				dropdownArrow.Position = UDim2.new(1, -40, 0, 0)
				dropdownArrow.BackgroundTransparency = 1
				dropdownArrow.Text = "▼"
				dropdownArrow.TextColor3 = Color3.fromRGB(150, 100, 255)
				dropdownArrow.TextSize = 12
				dropdownArrow.Font = Enum.Font.GothamBold
				dropdownArrow.Parent = dropdownButton
				
				local optionsContainer = Instance.new("Frame")
				optionsContainer.Size = UDim2.new(1, 0, 0, 0)
				optionsContainer.Position = UDim2.new(0, 0, 0, 40)
				optionsContainer.BackgroundTransparency = 1
				optionsContainer.Parent = dropdownFrame
				
				local optionsList = Instance.new("UIListLayout")
				optionsList.Padding = UDim.new(0, 2)
				optionsList.SortOrder = Enum.SortOrder.LayoutOrder
				optionsList.Parent = optionsContainer
				
				local isExpanded = false
				
				for _, option in ipairs(options) do
					local optionButton = Instance.new("TextButton")
					optionButton.Size = UDim2.new(1, 0, 0, 35)
					optionButton.BackgroundColor3 = Color3.fromRGB(30, 22, 45)
					optionButton.BorderSizePixel = 0
					optionButton.Text = option
					optionButton.TextColor3 = Color3.fromRGB(180, 180, 180)
					optionButton.TextSize = 14
					optionButton.Font = Enum.Font.Gotham
					optionButton.Parent = optionsContainer
					
					optionButton.MouseButton1Click:Connect(function()
						selectedValue.Text = option
						isExpanded = false
						dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
						dropdownArrow.Text = "▼"
						
						if callback then
							callback(option)
						end
					end)
				end
				
				dropdownButton.MouseButton1Click:Connect(function()
					isExpanded = not isExpanded
					if isExpanded then
						local contentHeight = #options * 37
						dropdownFrame.Size = UDim2.new(1, 0, 0, 40 + contentHeight)
						dropdownArrow.Text = "▲"
					else
						dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
						dropdownArrow.Text = "▼"
					end
				end)
				
				return {
					SetValue = function(self, value)
						selectedValue.Text = value
					end
				}
			end
			
			function Section:CreateTextBox(name, placeholder, callback)
				local textboxFrame = Instance.new("Frame")
				textboxFrame.Size = UDim2.new(1, 0, 0, 40)
				textboxFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
				textboxFrame.BorderSizePixel = 0
				textboxFrame.Parent = sectionContent
				
				local textboxCorner = Instance.new("UICorner")
				textboxCorner.CornerRadius = UDim.new(0, 8)
				textboxCorner.Parent = textboxFrame
				
				local textboxLabel = Instance.new("TextLabel")
				textboxLabel.Size = UDim2.new(0.4, 0, 1, 0)
				textboxLabel.Position = UDim2.new(0, 15, 0, 0)
				textboxLabel.BackgroundTransparency = 1
				textboxLabel.Text = name
				textboxLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
				textboxLabel.TextSize = 15
				textboxLabel.Font = Enum.Font.Gotham
				textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
				textboxLabel.Parent = textboxFrame
				
				local textbox = Instance.new("TextBox")
				textbox.Size = UDim2.new(0.5, 0, 0, 30)
				textbox.Position = UDim2.new(0.45, 0, 0.5, -15)
				textbox.BackgroundColor3 = Color3.fromRGB(30, 22, 45)
				textbox.BorderSizePixel = 0
				textbox.PlaceholderText = placeholder or ""
				textbox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
				textbox.Text = ""
				textbox.TextColor3 = Color3.fromRGB(200, 150, 255)
				textbox.TextSize = 14
				textbox.Font = Enum.Font.Gotham
				textbox.Parent = textboxFrame
				
				local textboxInputCorner = Instance.new("UICorner")
				textboxInputCorner.CornerRadius = UDim.new(0, 6)
				textboxInputCorner.Parent = textbox
				
				textbox.FocusLost:Connect(function()
					if callback then
						callback(textbox.Text)
					end
				end)
				
				return {
					SetValue = function(self, value)
						textbox.Text = value
					end
				}
			end
			
			return Section
		end
		
		return Tab
	end
	
	return Window
end

return Library
