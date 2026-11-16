//
//  JournalCard.swift
//  Journali
//
//  Created by Jumana Khawaij on 07/06/1448 AH.
//
import SwiftUI

struct JournalCard: View {
    
    let title: String
    let date: String
    let content: String
    let isBookmarked: Bool
    
    let onTap: () -> Void
    let onToggleBookmark: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGFloat = 0
    
    private let deleteButtonWidth: CGFloat = 58
    
    
    var body: some View {
        ZStack(alignment: .trailing) {
            
            Button {
                onDelete()
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: AppFonts.bodyM, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: deleteButtonWidth, height: 46)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 23))
            }
            
            VStack(alignment: .leading, spacing: 0) {
                
                HStack(alignment: .top) {
                    
                    VStack(alignment: .leading, spacing: 6) {
                        
                        Text(title)
                            .font(.system(size: AppFonts.headingM, weight: .semibold))
                            .foregroundStyle(Color.accentText)
                        
                        Text(date)
                            .font(.system(size: AppFonts.bodyM))
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                    
                    Button {
                        onToggleBookmark()
                    } label: {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            .font(.system(size: AppFonts.headingM))
                            .foregroundStyle(Color.accentText)
                            .contentTransition(.symbolEffect(.replace))
                    }
                    .buttonStyle(.plain)
                }
                
                Text(content)
                    .font(.system(size: AppFonts.bodyL))
                    .foregroundStyle(Color.primaryText)
                    .lineSpacing(2)
                    .lineLimit(5)
                    .padding(.top, 28)
            }
            .padding(28)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.cardSurface)
            .clipShape(RoundedRectangle(cornerRadius: 38))
            .offset(x: offset)
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onChanged { value in
                        guard abs(value.translation.width) >
                                abs(value.translation.height) else {
                            return
                        }
                        
                        let newOffset = value.translation.width
                        
                        if newOffset < 0 {
                            offset = max(
                                newOffset,
                                -deleteButtonWidth
                            )
                        }
                    }
                    .onEnded { value in
                        if value.translation.width < -40 {
                            offset = -deleteButtonWidth
                        } else if value.translation.width > 40 {
                            offset = 0
                        }
                    }
            )
            .animation(.spring(response: 0.3), value: offset)
        }
        .clipShape(RoundedRectangle(cornerRadius: 38))
        .onTapGesture {
            if offset == 0 {
                onTap()
            }
        }
    }
}

