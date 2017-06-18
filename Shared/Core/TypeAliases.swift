//
//  TypeAliases.swift
//  WaveLabs
//
//  Created by VG (DE) on 16.06.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import Foundation

public typealias GenericCompletion<T1, T2> = (T1) -> T2
public typealias Completion<T> = GenericCompletion<T, Void>
public typealias VoidCompletion = () -> Void
