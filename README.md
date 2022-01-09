# SwiftUI-Zoom-Scale-Drawer-LongTapGesture-TapGesture-MagnificationGesture-DragGesture

![mygif.gif](./mygif.gif)

```swift
//
//  ContentView.swift
//  PinchAndZoomSwiftUI3
//
//  Created by paige on 2022/01/10.
//

import SwiftUI

struct ContentView: View {

    // MARK: - PROPERTY
    @State private var isAnimating = false
    // For Zoom in an Zoom out
    @State private var imageScale: CGFloat = 1
    // For Drag Effect
    @State private var imageOffset: CGSize = CGSize(width: 0, height: 0)
    // DRAWER
    @State private var isDrawerOpen = false

    private let pages: [Page] = pagesData
    @State private var pageIndex = 1

    // MARK: - FUNCTION

    func resetImageState() {
        return withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }

    func currentPage() -> String {
        return pages[pageIndex - 1].imageName
    }

    // MARK: - CONTENT

    var body: some View {
        NavigationView {
            ZStack {
                // Put InfoPanel On Top of ZStack
                // Overlay on top of ZStack
                Color.clear

                // MARK: - PAGE IMAGE
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
            } //: ZSTACK
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            // MARK: - 1. TAP GESTURE, Double Tab Scale Effect
            .onTapGesture(count: 2) {
                if imageScale == 1 {
                    withAnimation(.spring()) {
                        imageScale = 5
                    }
                } else {
                    resetImageState()
                }
            }
            // MARK: - 2. DRAG
            .gesture(
                DragGesture()
                    .onChanged { value in
                        withAnimation(.linear(duration: 1)) {
                            imageOffset = value.translation
                        }
                    }
                    .onEnded{ _ in
                        if imageScale <= 1 {
                            resetImageState()
                        }
                    }
            )
            // MARK: - 3. MAGNIFICATION
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        withAnimation(.linear(duration: 1)) {
                            if imageScale >= 1 && imageScale <= 5 {
                                imageScale = value
                            } else if imageScale > 5 {
                                imageScale = 5
                            }
                        }
                    }
                    .onEnded { _ in
                        if imageScale > 5 {
                            imageScale = 5
                        } else if imageScale <= 1 {
                            resetImageState()
                        }
                    }
            )
            .onAppear {
                withAnimation(.linear(duration: 1)) {
                    isAnimating = true
                }
            }
            // MARK: - INFO PANEL
            .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(),
                alignment: .top
            )
            // MARK: - CONTROLS
            .overlay(
                Group {
                    HStack {
                        // SCALE DOWN
                        Button {
                            withAnimation(.spring()) {
                                if imageScale > 1 {
                                    imageScale -= 1

                                    if imageScale <= 1 {
                                        resetImageState()
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: "minus.magnifyingglass")
                                .font(.system(size: 36))
                        }

                        // RESET
                        Button {
                            resetImageState()
                        } label: {
                            Image(systemName: "arrow.up.left.and.down.right.magnifyingglass")
                                .font(.system(size: 36))
                        }

                        // SCALE UP
                        Button {
                            withAnimation(.spring()) {
                                if imageScale < 5 {
                                    imageScale += 1
                                    if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: "plus.magnifyingglass")
                                .font(.system(size: 36))
                        }


                    } //: CONTROLS
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                }
                .padding(.bottom, 30),
                alignment: .bottom
            )
            // MARK: - DRAWER
            .overlay(
                HStack(spacing: 12) {
                    // MARK: - DRAWER HANDLE
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            withAnimation(.easeOut) {
                                isDrawerOpen.toggle()
                            }
                        }
                    // MARK: - THUMBNAILS
                    ForEach(pages) { item in
                        Image(item.thumbnailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                            .onTapGesture {
                                isAnimating = true
                                pageIndex = item.id
                            }
                    }

                    Spacer()
                } //: DRAWER
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .opacity(isAnimating ? 1 : 0)
                .frame(width: 260)
                .padding(.top, UIScreen.main.bounds.height / 12)
                .offset(x: isDrawerOpen ? 20 : 215),
                alignment: .topTrailing
            )
        } //: NAVIGATION
        .navigationViewStyle(.stack)
    }
}

```

```swift
struct InfoPanelView: View {

    var scale: CGFloat
    var offset: CGSize
    @State private var isInfoPanelVisible = false

    var body: some View {
        HStack {
            // MARK: - HOTSPOT
            Image(systemName: "circle.circle")
                .symbolRenderingMode(.hierarchical)
                .resizable()
                .frame(width: 30, height: 30)
                .onLongPressGesture(minimumDuration: 1) {
                    withAnimation(.easeOut) {
                        isInfoPanelVisible.toggle()
                    }
                }
            Spacer()
            // MARK: - INFO PANEL
            HStack(spacing: 2) {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                Text("\(scale)")
                Spacer()
                Image(systemName: "arrow.left.and.right")
                Text("\(offset.width)")
                Spacer()
                Image(systemName: "arrow.up.and.down")
                Text("\(offset.height)")
                Spacer()
            } //: HSTACK
            .font(.footnote)
            .padding(8)
            .background(.ultraThinMaterial)
            .cornerRadius(8)
            .frame(maxWidth: 420)
            .opacity(isInfoPanelVisible ? 1 : 0)
            Spacer()
        } //: HSTACK
    }
}
```

```swift
struct ControlImageView: View {
    let icon: String

    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 36))
    }
}

struct ControlImageView_Previews: PreviewProvider {
    static var previews: some View {
        ControlImageView(icon: "minus.magnifyingglass")
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
```

```swift
import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
}

let pagesData: [Page] = [
    Page(id: 1, imageName: "magazine-front-cover"),
    Page(id: 2, imageName: "magazine-back-cover"),
]

extension Page {
    var thumbnailName: String {
        return "thumb-" + imageName
    }
}
```
