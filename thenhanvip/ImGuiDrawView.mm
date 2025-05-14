//Require standard library
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <Foundation/Foundation.h>
#include <iostream>
#include <UIKit/UIKit.h>
#include <vector>
#import "pthread.h"
#include <array>
#import <os/log.h>
#include <cmath>
#include <deque>
#include <fstream>
#include <algorithm>
#include <string>
#include <sstream>
#include <cstring>
#include <cstdlib>
#include <cstdio>
#include <cstdint>
#include <cinttypes>
#include <cerrno>
#include <cctype>
//Imgui library
#import "Esp/CaptainHook.h"
#import "Esp/ImGuiDrawView.h"
#import "IMGUI/imgui.h"
#import "IMGUI/imgui_internal.h"
#import "IMGUI/imgui_impl_metal.h"
#import "IMGUI/zzz.h"
#include "oxorany/oxorany_include.h"
#import "Helper/Mem.h"
#include "font.h"
#import "Helper/Vector3.h"
#import "Helper/Vector2.h"
#import "Helper/Quaternion.h"
#import "Helper/Monostring.h"
#include "Helper/font.h"
#include "Helper/data.h"
ImFont* verdana_smol;
ImFont* pixel_big = {};
ImFont* pixel_smol = {};
#include "Helper/Obfuscate.h"
#import "Helper/Hooks.h"
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include <unistd.h>
#include <string.h>

#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kScale [UIScreen mainScreen].scale

@interface ImGuiDrawView () <MTKViewDelegate>
@property (nonatomic, strong) id <MTLDevice> device;
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;
@end

@implementation ImGuiDrawView
ImFont *_espFont;
ImFont* verdanab;
ImFont* icons;
ImFont* interb;
ImFont* Urbanist;
static bool MenDeal = true;


- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    _device = MTLCreateSystemDefaultDevice();
    _commandQueue = [_device newCommandQueue];

    if (!self.device) abort();

    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO(); (void)io;

   ImGui::StyleColorsClassic();
    auto& Style = ImGui::GetStyle();
    Style.WindowPadding = ImVec2(8.0f, 8.0f);
    Style.FramePadding = ImVec2(9.0f, 7.0f);
    Style.ScrollbarRounding = 9.0f;
            ImVec4* colors = ImGui::GetStyle().Colors;
        colors[ImGuiCol_Text] = ImVec4(0.5f, 1.0f, 0.5f, 1.0f); // Xanh lá neon
        colors[ImGuiCol_WindowBg] = ImVec4(0.06f, 0.06f, 0.06f, 1.00f);
        colors[ImGuiCol_PopupBg] = ImVec4(0.09f, 0.09f, 0.09f, 1.00f);
        colors[ImGuiCol_FrameBg] = ImVec4(0.4f, 0.2f, 0.5f, 0.54f);
        colors[ImGuiCol_FrameBgHovered] = ImVec4(0.5f, 0.3f, 0.6f, 0.80f); 
        colors[ImGuiCol_FrameBgActive] = ImVec4(0.4f, 0.2f, 0.5f, 1.00f);
        colors[ImGuiCol_TitleBg] = ImVec4(0.06f, 0.06f, 0.06f, 1.00f);
        colors[ImGuiCol_TitleBgActive] = ImVec4(0.14f, 0.14f, 0.14f, 1.00f);
        colors[ImGuiCol_CheckMark] = ImColor(255, 223, 0).Value;
        colors[ImGuiCol_ScrollbarBg] = ImVec4(0, 0, 0, 0);
        colors[ImGuiCol_ScrollbarGrab] = ImColor(163, 122, 195).Value;
        colors[ImGuiCol_ScrollbarGrabHovered] = ImColor(163, 122, 195).Value;
        colors[ImGuiCol_ScrollbarGrabActive] = ImColor(163, 122, 195).Value;
        colors[ImGuiCol_SliderGrab] = ImColor(163, 122, 195).Value;
        colors[ImGuiCol_SliderGrabActive] = ImColor(163, 122, 195).Value;
        colors[ImGuiCol_Button] = ImVec4(0.24f, 0.24f, 0.24f, 0.40f);
        colors[ImGuiCol_ButtonHovered] = ImVec4(0.25f, 0.25f, 0.25f, 1.00f);
        colors[ImGuiCol_ButtonActive] = ImVec4(0.32f, 0.32f, 0.32f, 1.00f);
        colors[ImGuiCol_Header] = ImVec4(0.73f, 0.73f, 0.73f, 0.31f);
        colors[ImGuiCol_HeaderHovered] = ImVec4(0.65f, 0.65f, 0.65f, 0.80f);
        colors[ImGuiCol_HeaderActive] = ImVec4(0.72f, 0.72f, 0.72f, 1.00f);
        colors[ImGuiCol_Separator] = ImVec4(0.50f, 0.50f, 0.50f, 0.50f);
        colors[ImGuiCol_SeparatorHovered] = ImVec4(0.52f, 0.52f, 0.52f, 0.78f);
        colors[ImGuiCol_SeparatorActive] = ImVec4(0.49f, 0.49f, 0.49f, 1.00f);
        colors[ImGuiCol_ResizeGrip] = ImColor(163, 122, 195).Value;
        colors[ImGuiCol_ResizeGripHovered] = ImColor(163, 122, 195).Value;
        colors[ImGuiCol_ResizeGripActive] = ImColor(163, 122, 195).Value;
        colors[ImGuiCol_Tab] = ImVec4(0.17f, 0.17f, 0.17f, 0.86f);
        colors[ImGuiCol_TabHovered] = ImVec4(0.29f, 0.29f, 0.29f, 0.80f);
        colors[ImGuiCol_TabActive] = ImVec4(0.40f, 0.40f, 0.40f, 1.00f);
        colors[ImGuiCol_TabUnfocused] = ImVec4(0.11f, 0.11f, 0.11f, 0.97f);
        colors[ImGuiCol_TabUnfocusedActive] = ImVec4(0.17f, 0.17f, 0.17f, 1.00f);
        colors[ImGuiCol_TextSelectedBg] = ImVec4(0.59f, 0.11f, 0.11f, 0.35f);
        colors[ImGuiCol_NavHighlight] = ImVec4(0.28f, 0.28f, 0.28f, 1.00f);
        ImGui::GetStyle().Colors[ImGuiCol_WindowBg] = ImVec4(0.11f, 0.11f, 0.11f, 0.8f);
        ImGui::GetStyle().Colors[ImGuiCol_Border] = ImColor(36, 36, 38);
        ImGui::GetStyle().Colors[ImGuiCol_ChildBg] = ImColor(36, 36, 38);

        ImGui::GetStyle().WindowRounding = 8 / 1.5f;
        ImGui::GetStyle().FrameRounding = 4 / 1.5f;
        ImGui::GetStyle().ChildRounding = 6 / 1.5f;
    ImFont* font = io.Fonts->AddFontFromMemoryTTF(sansbold, sizeof(sansbold), 15.0f, NULL, io.Fonts->GetGlyphRangesCyrillic());
    verdana_smol = io.Fonts->AddFontFromMemoryTTF(verdana, sizeof verdana, 40, NULL, io.Fonts->GetGlyphRangesCyrillic());
    pixel_big = io.Fonts->AddFontFromMemoryTTF((void*)smallestpixel, sizeof smallestpixel, 128, NULL, io.Fonts->GetGlyphRangesCyrillic());
    pixel_smol = io.Fonts->AddFontFromMemoryTTF((void*)smallestpixel, sizeof smallestpixel, 10*2, NULL, io.Fonts->GetGlyphRangesCyrillic());
    ImGui_ImplMetal_Init(_device);

    return self;
}
+ (void)showChange:(BOOL)open
{
    MenDeal = open;
}
- (MTKView *)mtkView
{
    return (MTKView *)self.view;
}
- (void)loadView
{
    CGFloat w = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width;
    CGFloat h = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height;
    self.view = [[MTKView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mtkView.device = self.device;
    self.mtkView.delegate = self;
    self.mtkView.clearColor = MTLClearColorMake(0, 0, 0, 0);
    self.mtkView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.mtkView.clipsToBounds = YES;

}



#pragma mark - Interaction

- (void)updateIOWithTouchEvent:(UIEvent *)event
{
    UITouch *anyTouch = event.allTouches.anyObject;
    CGPoint touchLocation = [anyTouch locationInView:self.view];
    ImGuiIO &io = ImGui::GetIO();
    io.MousePos = ImVec2(touchLocation.x, touchLocation.y);

    BOOL hasActiveTouch = NO;
    for (UITouch *touch in event.allTouches)
    {
        if (touch.phase != UITouchPhaseEnded && touch.phase != UITouchPhaseCancelled)
        {
            hasActiveTouch = YES;
            break;
        }
    }
    io.MouseDown[0] = hasActiveTouch;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

#pragma mark - MTKViewDelegate

void DrawMovingWeb(ImDrawList* drawList, ImVec2 menuPos, ImVec2 menuSize) {
    static std::vector<ImVec2> nodes;
    static std::vector<ImVec2> velocities;
    static float timeElapsed = 0.0f;
    static float hue = 0.0f; 
    static ImColor currentColor = ImColor::HSV(hue, 1.0f, 1.0f); 
    float maxDistance = 80.0f; 
    float speed = 0.6f; 

    ImVec2 menuEnd = ImVec2(menuPos.x + menuSize.x, menuPos.y + menuSize.y);

   
    if (nodes.empty()) {
        for (int i = 0; i < 20; i++) {
            float x = menuPos.x + (rand() % (int)menuSize.x);
            float y = menuPos.y + (rand() % (int)menuSize.y);
            nodes.push_back(ImVec2(x, y));

            // Tạo vận tốc ngẫu nhiên
            float vx = (rand() % 100 - 50) / 100.0f * speed;
            float vy = (rand() % 100 - 50) / 100.0f * speed;
            velocities.push_back(ImVec2(vx, vy));
        }
    }

  
    timeElapsed += ImGui::GetIO().DeltaTime;
    if (timeElapsed >= 0.02f) { 
        timeElapsed = 0.0f;
        hue += 0.01f; 
        if (hue > 1.0f) hue -= 1.0f; 
        currentColor = ImColor::HSV(hue, 1.0f, 1.0f); 
    }
    for (size_t i = 0; i < nodes.size(); i++) {
        nodes[i].x += velocities[i].x;
        nodes[i].y += velocities[i].y;

     
        if (nodes[i].x <= menuPos.x || nodes[i].x >= menuEnd.x) {
            velocities[i].x *= -1; 
        }
        if (nodes[i].y <= menuPos.y || nodes[i].y >= menuEnd.y) {
            velocities[i].y *= -1; 
        }
 
        nodes[i].x = std::clamp(nodes[i].x, menuPos.x, menuEnd.x);
        nodes[i].y = std::clamp(nodes[i].y, menuPos.y, menuEnd.y);
    }
    for (auto& node : nodes) {
        drawList->AddCircleFilled(node, 2, IM_COL32(255, 255, 255, 255));

        for (auto& other : nodes) {
            float dx = node.x - other.x;
            float dy = node.y - other.y;
            float distance = sqrt(dx * dx + dy * dy);

            if (distance < maxDistance) {
                float alpha = 1.0f - (distance / maxDistance);
                ImColor lineColor = ImColor(
                    currentColor.Value.x * 255,
                    currentColor.Value.y * 255,
                    currentColor.Value.z * 255,
                    alpha * 255
                );

                drawList->AddLine(node, other, lineColor);
            }
        }
    }
}


- (void)drawInMTKView:(MTKView*)view
{
    ImGuiIO& io = ImGui::GetIO();
    io.DisplaySize.x = view.bounds.size.width;
    io.DisplaySize.y = view.bounds.size.height;

    CGFloat framebufferScale = view.window.screen.nativeScale ?: UIScreen.mainScreen.nativeScale;
    io.DisplayFramebufferScale = ImVec2(framebufferScale, framebufferScale);
    io.DeltaTime = 1 / float(view.preferredFramesPerSecond ?: 60);
    
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
        
    if (MenDeal == true) {
        [self.view setUserInteractionEnabled:YES];
    } else {
        [self.view setUserInteractionEnabled:NO];
    }

    MTLRenderPassDescriptor* renderPassDescriptor = view.currentRenderPassDescriptor;
    if (renderPassDescriptor != nil)
    {
        id <MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        [renderEncoder pushDebugGroup:@"ImGui Jane"];

        ImGui_ImplMetal_NewFrame(renderPassDescriptor);
        ImGui::NewFrame();

        UIWindow *mainWindow = [UIApplication.sharedApplication.windows firstObject];
        CGFloat x = (mainWindow.bounds.size.width - 380) / 2;
        CGFloat y = (mainWindow.bounds.size.height - 260) / 2;

        ImGui::SetNextWindowPos(ImVec2(x, y), ImGuiCond_FirstUseEver);
        ImGui::SetNextWindowSize(ImVec2(365, 270), ImGuiCond_FirstUseEver);

        if (MenDeal == true)
        {                
            ImGui::Begin(oxorany("Nguyen LanLan - Free Fire Menu"), &MenDeal);
            // Lấy danh sách vẽ trong menu
            ImDrawList* draw_list = ImGui::GetWindowDrawList();
            
            // Lấy vị trí và kích thước menu
            ImVec2 menuPos = ImGui::GetWindowPos();
            ImVec2 menuSize = ImGui::GetWindowSize();

            // Gọi hiệu ứng chất điểm trong menu
            DrawMovingWeb(draw_list, menuPos, menuSize);
            if (ImGui::BeginTabBar(oxorany("Tab"),ImGuiTabBarFlags_FittingPolicyScroll)) {
                if (ImGui::BeginTabItem(("ESP"))) {
                    ImGui::Checkbox(oxorany("Enable Cheats"), &Vars.Enable);
                    if (ImGui::BeginTable("split", 4))
                    {
                        ImGui::TableNextColumn();
                        ImGui::Checkbox(oxorany("Line"), &Vars.lines);
                        ImGui::TableNextColumn();
                        ImGui::Checkbox(oxorany("Box"), &Vars.Box);
                        ImGui::TableNextColumn();
                        ImGui::Checkbox(oxorany("Health"), &Vars.Health);
                        ImGui::TableNextColumn();
                        ImGui::Checkbox(oxorany("Name"), &Vars.Name);
                        ImGui::TableNextColumn();
                        ImGui::Checkbox(oxorany("Skeleton"), &Vars.skeleton);
                        ImGui::TableNextColumn();
                        ImGui::Checkbox(oxorany("Distance"), &Vars.Distance);
                        ImGui::TableNextColumn();
                        ImGui::Checkbox(oxorany("3D Circle"), &Vars.circlepos);
                        ImGui::TableNextColumn();
                        ImGui::Checkbox(oxorany("Outline"), &Vars.Outline);
                    }
                    ImGui::EndTable();
                    ImGui::Checkbox(oxorany("Out of Screen"), &Vars.OOF);
                    ImGui::SameLine();
                    ImGui::EndTabItem();
                }
                if (ImGui::BeginTabItem(("AimBot"))) {
                    ImGui::Spacing();
                    ImGui::Checkbox(oxorany("Enable Aimbot"), &Vars.Aimbot);
                    ImGui::Combo(oxorany("Aim When"), &Vars.AimWhen, Vars.dir, 4);
                    ImGui::SliderFloat(oxorany("Aim FOV"), &Vars.AimFov, 0.0f, 500.0f);
                    ImGui::Checkbox(oxorany("FOV Glow"), &Vars.fovaimglow);
                    if (Vars.fovaimglow) {
                        ImGui::ColorEdit4(oxorany("FOV Color"), Vars.fovLineColor);
                    }
                    ImGui::EndTabItem();
                }
                if (ImGui::BeginTabItem(("Info Developer"))) {
                    ImGui::TextDisabled("Project By NHLHL");
                    if (ImGui::Button("Zalo")) {
                        NSURL *zaloURL = [NSURL URLWithString:@"https://zalo.me/09715536171553617"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[UIApplication sharedApplication] openURL:zaloURL options:@{} completionHandler:nil];
                        });
                    }
                    ImGui::SameLine();
                    if (ImGui::Button("Facebook")) {
                        NSURL *tiktokURL = [NSURL URLWithString:@"https://www.facebook.com/];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[UIApplication sharedApplication] openURL:tiktokURL options:@{} completionHandler:nil];
                        });
                    }
                    ImGui::EndTabItem();
                }
                ImGui::EndTabBar();
            }
            ImGui::End();
        }


        get_players();
        draw_watermark();
        aimbot();
        game_sdk->init();
        Vars.isAimFov = (Vars.AimFov > 0);

        ImGui::Render();
        ImDrawData* draw_data = ImGui::GetDrawData();
        ImGui_ImplMetal_RenderDrawData(draw_data, commandBuffer, renderEncoder);

        [renderEncoder popDebugGroup];
        [renderEncoder endEncoding];

        [commandBuffer presentDrawable:view.currentDrawable];
    }

    [commandBuffer commit];
}


- (void)mtkView:(MTKView*)view drawableSizeWillChange:(CGSize)size
{
    
}

@end

